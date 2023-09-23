local formatter_table = {}
local langs = require('utils.static').langs
for lang, _ in pairs(langs) do
  if langs[lang].formatters then
    formatter_table[lang] = langs[lang].formatters
  end
end

require('conform').setup {
  formatters_by_ft = formatter_table,
  format_on_save = function(bufnr)
    if vim.g.autoformat or vim.b[bufnr].autoformat then
      return { timeout_ms = 500, lsp_fallback = true }
    end
  end,
}

vim.g.autoformat = true
vim.api.nvim_create_user_command('AutoFormatDisable', function(args)
  if args.bang then
    vim.b.autoformat = false
  else
    vim.g.autoformat = false
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('AutoFormatEnable', function()
  vim.b.autoformat = true
  vim.g.autoformat = true
end, {
  desc = 'Re-enable autoformat-on-save',
})

require('conform.formatters.black').args = { '--line-length', '79' }
require('conform.formatters.shfmt').args =
  { '--indent', vim.bo.et and tostring(vim.bo.ts) or '0' }

vim.lsp.buf.format = require('conform').format
