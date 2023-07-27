local static = require 'utils.static'
local server_configs = require 'plugins.configs.lsp-server-configs'

local border = require('core.settings').border

---Customize LSP floating window border
local function lspconfig_floating_preview()
  local opts_override = {}

  ---Update LSP floating preview window options
  local function update_floating_preview_opts()
    opts_override = {
      border = border,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
        'WinScrolled',
      },
    }
  end
  update_floating_preview_opts()
  -- Reset LSP floating window options on VimResized
  vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('LspFloatingWinOpts', {}),
    callback = update_floating_preview_opts,
  })

  -- Hijack LSP floating window function to use custom options
  local _open_floating_preview = vim.lsp.util.open_floating_preview
  ---@param contents table of lines to show in window
  ---@param syntax string of syntax to set for opened buffer
  ---@param opts table with optional fields (additional keys are passed on to |nvim_open_win()|)
  ---@returns bufnr,winnr buffer and window number of the newly created floating
  ---preview window
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts)
    local source_ft = vim.bo[vim.api.nvim_get_current_buf()].ft
    opts = vim.tbl_deep_extend('force', opts, opts_override)
    -- If source filetype if markdown or tex, use markdown syntax
    -- and disable stylizing markdown to get math concealing provided
    -- by vimtex in the floating window
    if source_ft == 'markdown' or source_ft == 'tex' then
      opts.stylize_markdown = false
      syntax = 'markdown'
    end
    return _open_floating_preview(contents, syntax, opts)
  end
end

---Customize LSP diagnostic UI
local function lspconfig_diagnostics()
  local icons = static.icons
  for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
    local sign_name = 'DiagnosticSign' .. severity
    vim.fn.sign_define(sign_name, {
      text = icons[sign_name],
      texthl = sign_name,
      numhl = sign_name,
      culhl = sign_name .. 'Cul',
    })
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    -- virtual_text = {
    --   spacing = 4,
    --   prefix = vim.trim(static.icons.AngleLeft),
    -- },
    -- Provided by lsp_lines.nvim
    virtual_text = false,
  })

  -- Disable LSP diagnostics in diff mode
  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'diff',
    group = vim.api.nvim_create_augroup('DiagnosticDisableInDiff', {}),
    callback = function(info)
      if vim.v.option_new == '1' then
        vim.diagnostic.disable(info.buf)
        vim.b._lsp_diagnostics_temp_disabled = true
      elseif vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1 and vim.b._lsp_diagnostics_temp_disabled then
        vim.diagnostic.enable(info.buf)
        vim.b._lsp_diagnostics_temp_disabled = nil
      end
    end,
    desc = 'Disable LSP diagnostics in diff mode.',
  })
end

---Customize LspInfo floating window
local function lspconfig_info_win()
  -- setup LspInfo floating window border
  require('lspconfig.ui.windows').default_options.border = border
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

local function lspconfig_goto_handers()
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
        vim.notify('[LSP] no ' .. method:match '/(%w*)$' .. ' found', vim.log.levels.WARN)
      end
      handler(err, result, ctx, cfg)
    end
  end
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
      callback = function()
        if setup_ft(ft) then
          -- Trigger lspconfig filetype autocmds to launch LSP servers
          vim.cmd('doautocmd Filetype ' .. ft)
        end
        return true
      end,
    })
  end
end

lspconfig_floating_preview()
lspconfig_diagnostics()
lspconfig_info_win()
lspconfig_goto_handers()
lsp_setup()
