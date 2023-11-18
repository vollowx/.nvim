local linter_table = {}
local langs = require('utils.static').langs
for lang, _ in pairs(langs) do
  if langs[lang].linters then linter_table[lang] = langs[lang].linters end
end

require('lint').linters_by_ft = linter_table
