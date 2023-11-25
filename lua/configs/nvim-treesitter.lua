local ts_configs = require 'nvim-treesitter.configs'

-- Get all filetypes that have treesitter parsers
local ts_filetypes = {}
local langs = require('utils.static').langs
for lang, _ in pairs(langs) do
  if langs[lang].ts then table.insert(ts_filetypes, langs[lang].ft) end
end

-- Set treesitter folds
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('TSFolds', {}),
  callback = function(tbl)
    if vim.tbl_contains(ts_filetypes, tbl.match) then
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt_local.foldtext = 'v:lua.vim.treesitter.foldtext()'
    end
  end,
})

ts_configs.setup {
  auto_install = true,
  modules = {},
  ignore_install = {},
  ensure_installed = require('utils.static').langs:list 'ts',
  sync_install = false,
  highlight = {
    enable = not vim.g.vscode,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = '+',
      node_decremental = '-',
    },
  },
  endwise = { enable = true },
}
