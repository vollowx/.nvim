---Customize LspInfo floating window
require('lspconfig.ui.windows').default_options.border = PREF.ui.border
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Reload LspInfo floating window on VimResized.',
  group = vim.api.nvim_create_augroup('LspInfoResize', {}),
  callback = function()
    if vim.bo.ft == 'lspinfo' then
      vim.api.nvim_win_close(0, true)
      vim.cmd 'LspInfo'
    end
  end,
})

---Setup all LSP servers
local lspconfig = require 'lspconfig'
local servers = PREF.lsp_servers
local server_ = require 'configs.lsp'
for _, server in ipairs(servers) do
  lspconfig[server].setup(server_[server])
end

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

-- Configure hovering window style
local opts_override_floating_preview = {
  border = PREF.ui.border_hover,
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
  opts = vim.tbl_deep_extend('force', opts, opts_override_floating_preview)
  local floating_bufnr, floating_winnr =
    _open_floating_preview(contents, syntax, opts)
  vim.wo[floating_winnr].concealcursor = 'nc'
  return floating_bufnr, floating_winnr
end

vim.diagnostic.config {
  update_in_insert = true,
  virtual_text = {
    spacing = 4,
    prefix = vim.trim(PREF.icons.ui.AngleLeft),
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = PREF.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = PREF.icons.diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = PREF.icons.diagnostics.Info,
      [vim.diagnostic.severity.HINT] = PREF.icons.diagnostics.Hint,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
  },
}

local map = vim.keymap.set

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

-- map({ 'n' }, 'gq;', vim.lsp.buf.format)
map({ 'n', 'x' }, '<Leader>ca', vim.lsp.buf.code_action)
map({ 'n', 'x' }, '<Leader>r', vim.lsp.buf.rename)
map({ 'n', 'x' }, '<Leader>e', vim.diagnostic.open_float)
map({ 'n', 'x' }, '<leader>E', vim.diagnostic.setloclist)
map({ 'n', 'x' }, '[e', vim.diagnostic.goto_prev)
map({ 'n', 'x' }, ']e', vim.diagnostic.goto_next)
map({ 'n', 'x' }, '[E', goto_diagnostic('prev', 'ERROR'))
map({ 'n', 'x' }, ']E', goto_diagnostic('next', 'ERROR'))
map({ 'n', 'x' }, '[W', goto_diagnostic('prev', 'WARN'))
map({ 'n', 'x' }, ']W', goto_diagnostic('next', 'WARN'))
map({ 'n', 'x' }, '[I', goto_diagnostic('prev', 'INFO'))
map({ 'n', 'x' }, ']I', goto_diagnostic('next', 'INFO'))
map({ 'n', 'x' }, '[H', goto_diagnostic('prev', 'HINT'))
map({ 'n', 'x' }, ']H', goto_diagnostic('next', 'HINT'))
map({ 'n', 'x' }, 'g.', function() vim.lsp.buf.references() end)
map({ 'n', 'x' }, 'gd', function() vim.lsp.buf.definition() end)
map({ 'n', 'x' }, 'gD', function() vim.lsp.buf.type_definition() end)
