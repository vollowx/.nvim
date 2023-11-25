local utils = require 'utils'
local static = require 'utils.static'
local server_configs = require 'configs.lsp-server-configs'

---Set up diagnostic signs
---@return nil
local function setup_diagnostic_signs()
  local icons = utils.static.icons
  for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
    local sign_name = 'DiagnosticSign' .. severity
    vim.fn.sign_define(sign_name, {
      text = icons.diagnostics[sign_name],
      texthl = sign_name,
      numhl = sign_name,
      culhl = sign_name .. 'Cul',
    })
  end
end

---Check if there exists an LS that supports the given method
---for the given buffer
---@param method string the method to check for
---@param bufnr number buffer handler
local function supports_method(method, bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    if client.supports_method(method) then return true end
  end
  return false
end

---Setup LSP keymaps
---@return nil
local function setup_keymaps()
  ---@param direction 'prev'|'next'
  ---@param level 'ERROR'|'WARN'|'INFO'|'HINT'
  ---@return function
  local function goto_diagnostic(direction, level)
    return function()
      vim.diagnostic['goto_' .. direction] {
        severity = vim.diagnostic.severity[level],
      }
    end
  end
  ---@param method string LSP method
  ---@param fn_name string function name, used to index vim.lsp.buf
  ---@param fallback string fallback keymap
  ---@return function
  local function if_supports_lsp_method(method, fn_name, fallback)
    return function()
      return supports_method(method, 0)
          and string.format(
            '<Cmd>lua vim.lsp.buf["%s"]()<CR>',
            vim.fn.escape(fn_name, '"\\')
          )
        or fallback
    end
  end
  -- stylua: ignore start
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
  vim.keymap.set('n', 'gr', vim.lsp.buf.rename)
  vim.keymap.set('n', 'ge', vim.diagnostic.open_float)
  vim.keymap.set('n', 'gE', vim.diagnostic.setqflist)
  vim.keymap.set('n', 'gF', vim.lsp.buf.format)
  vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
  vim.keymap.set('n', '[E', goto_diagnostic('prev', 'ERROR'))
  vim.keymap.set('n', ']E', goto_diagnostic('next', 'ERROR'))
  vim.keymap.set('n', '[W', goto_diagnostic('prev', 'WARN'))
  vim.keymap.set('n', ']W', goto_diagnostic('next', 'WARN'))
  vim.keymap.set('n', '[I', goto_diagnostic('prev', 'INFO'))
  vim.keymap.set('n', ']I', goto_diagnostic('next', 'INFO'))
  vim.keymap.set('n', '[H', goto_diagnostic('prev', 'HINT'))
  vim.keymap.set('n', ']H', goto_diagnostic('next', 'HINT'))
  vim.keymap.set('n', 'gR', vim.lsp.buf.references)
  vim.keymap.set('n', 'gd', if_supports_lsp_method('textDocument/definition', 'definition', 'gd'), { expr = true })
  vim.keymap.set('n', 'gD', if_supports_lsp_method('textDocument/typeDefinition', 'type_definition', 'gD'),
    { expr = true })
  vim.keymap.set('n', 'K', if_supports_lsp_method('textDocument/hover', 'hover', 'K'), { expr = true })
  -- stylua: ignore end
end

---Setup LSP handlers overrides
---@return nil
local function setup_lsp_overrides()
  -- Show notification if no references, definition, declaration,
  -- implementation or type definition is found
  local handlers = {
    ['textDocument/references'] = vim.lsp.handlers['textDocument/references'],
    ['textDocument/definition'] = vim.lsp.handlers['textDocument/definition'],
    ['textDocument/declaration'] = vim.lsp.handlers['textDocument/declaration'],
    ['textDocument/implementation'] = vim.lsp.handlers['textDocument/implementation'],
    ['textDocument/typeDefinition'] = vim.lsp.handlers['textDocument/typeDefinition'],
  }
  for method, handler in pairs(handlers) do
    vim.lsp.handlers[method] = function(err, result, ctx, cfg)
      if not result or type(result) == 'table' and vim.tbl_isempty(result) then
        vim.notify(
          '[LSP] no ' .. method:match '/(%w*)$' .. ' found',
          vim.log.levels.WARN
        )
      end
      handler(err, result, ctx, cfg)
    end
  end

  -- Configure diagnostics style
  vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Enable underline, use default values
      underline = true,
      -- Enable virtual text, override spacing to 4
      virtual_text = {
        spacing = 4,
        prefix = vim.trim(utils.static.icons.ui.AngleLeft),
      },
      -- Enable in insert mode
      update_in_insert = true,
    })
end

---Customize LspInfo floating window
local function lspconfig_info_win()
  -- setup LspInfo floating window border
  require('lspconfig.ui.windows').default_options.border = 'shadow'
  -- reload LspInfo floating window on VimResized
  vim.api.nvim_create_autocmd('VimResized', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('LspInfoResize', {}),
    callback = function()
      if vim.bo.ft == 'lspinfo' then
        vim.api.nvim_win_close(0, true)
        vim.cmd 'LspInfo'
      end
    end,
  })
end

---Setup all LSP servers
local function lsp_setup()
  local lspconfig = require 'lspconfig'
  local ft_servers = static.langs:map 'lsp_server'
  ---@param ft string file type
  ---@return boolean? is_setup
  local function setup_ft(ft)
    local servers = ft_servers[ft]
    if not servers then return false end
    if type(servers) ~= 'table' then servers = { servers } end
    for _, server in ipairs(servers) do
      lspconfig[server].setup(server_configs[server])
    end
    ft_servers[ft] = nil
    vim.api.nvim_exec_autocmds('FileType', { pattern = ft })
    return true
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    setup_ft(vim.bo[buf].ft)
  end
  local groupid = vim.api.nvim_create_augroup('LspServerLazySetup', {})
  for ft, _ in pairs(ft_servers) do
    vim.api.nvim_create_autocmd('FileType', {
      once = true,
      pattern = ft,
      group = groupid,
      callback = function() return setup_ft(ft) end,
    })
  end
end

setup_diagnostic_signs()
setup_keymaps()
setup_lsp_overrides()
lspconfig_info_win()
lsp_setup()
