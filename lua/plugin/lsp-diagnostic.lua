local utils = require 'utils'

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
  vim.keymap.set('n', '[e', utils.keymap.count_wrap(vim.diagnostic.goto_prev))
  vim.keymap.set('n', ']e', utils.keymap.count_wrap(vim.diagnostic.goto_next))
  vim.keymap.set('n', '[E', utils.keymap.count_wrap(goto_diagnostic('prev', 'ERROR')))
  vim.keymap.set('n', ']E', utils.keymap.count_wrap(goto_diagnostic('next', 'ERROR')))
  vim.keymap.set('n', '[W', utils.keymap.count_wrap(goto_diagnostic('prev', 'WARN')))
  vim.keymap.set('n', ']W', utils.keymap.count_wrap(goto_diagnostic('next', 'WARN')))
  vim.keymap.set('n', '[I', utils.keymap.count_wrap(goto_diagnostic('prev', 'INFO')))
  vim.keymap.set('n', ']I', utils.keymap.count_wrap(goto_diagnostic('next', 'INFO')))
  vim.keymap.set('n', '[H', utils.keymap.count_wrap(goto_diagnostic('prev', 'HINT')))
  vim.keymap.set('n', ']H', utils.keymap.count_wrap(goto_diagnostic('next', 'HINT')))
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

  -- Configure hovering window style
  local opts_override_floating_preview = {
    border = 'solid',
    max_width = math.max(80, math.ceil(vim.go.columns * 0.75)),
    max_height = math.max(20, math.ceil(vim.go.lines * 0.4)),
    close_events = {
      'CursorMoved',
      'CursorMovedI',
      'WinScrolled',
    },
  }
  vim.api.nvim_create_autocmd('VimResized', {
    desc = 'Update LSP floating window maximum size on VimResized.',
    group = vim.api.nvim_create_augroup('LspUpdateFloatingWinMaxSize', {}),
    callback = function()
      opts_override_floating_preview.max_width =
        math.max(80, math.ceil(vim.go.columns * 0.75))
      opts_override_floating_preview.max_height =
        math.max(20, math.ceil(vim.go.lines * 0.4))
    end,
  })
  -- Hijack LSP floating window function to use custom options
  local _open_floating_preview = vim.lsp.util.open_floating_preview
  ---@param contents table of lines to show in window
  ---@param syntax string of syntax to set for opened buffer
  ---@param opts table with optional fields (additional keys are passed on to |nvim_open_win()|)
  ---@returns bufnr,winnr buffer and window number of the newly created floating preview window
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts)
    local source_ft = vim.bo[vim.api.nvim_get_current_buf()].ft
    opts = vim.tbl_deep_extend('force', opts, opts_override_floating_preview)
    -- If source filetype if markdown, use custom mkd syntax instead of
    -- markdown syntax to avoid using treesitter highlight and get math
    -- concealing provided by vimtex in the floating window
    if source_ft == 'markdown' then
      syntax = 'mkd'
      opts.wrap = false
    end
    local floating_bufnr, floating_winnr =
      _open_floating_preview(contents, syntax, opts)
    vim.wo[floating_winnr].concealcursor = 'nc'
    return floating_bufnr, floating_winnr
  end
end

---Set up diagnostic signs
---@return nil
local function setup_diagnostic_signs()
  local icons = utils.static.icons
  for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
    local sign_name = 'DiagnosticSign' .. severity
    vim.fn.sign_define(sign_name, {
      text = icons.diagnostics[severity],
      texthl = sign_name,
      numhl = sign_name,
      culhl = sign_name .. 'Cul',
    })
  end
end

---Set up LSP and diagnostic
---@return nil
local function setup()
  setup_keymaps()
  setup_lsp_overrides()
  setup_diagnostic_signs()
end

return {
  setup = setup,
}
