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
local server_ = require 'plugins._.lsp'
for _, server in ipairs(servers) do
  lspconfig[server].setup(server_[server])
end

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
