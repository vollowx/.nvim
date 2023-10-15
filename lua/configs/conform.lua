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

require('conform.formatters.black').args = { '--line-length', '79' }
require('conform.formatters.shfmt').args =
  { '--indent', vim.bo.et and tostring(vim.bo.ts) or '0' }
