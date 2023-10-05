local ts_configs = require 'nvim-treesitter.configs'

local border = require('core.settings').border

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
    end
  end,
})

ts_configs.setup {
  auto_install = true,
  modules = {},
  ignore_install = {},
  ensure_installed = require('utils.static').langs:list 'ts',
  sync_install = true,
  highlight = {
    enable = not vim.g.vscode,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = '<Enter>',
      node_decremental = '<Backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
        ['fo'] = '@function.outer',
        ['fi'] = '@function.inner',
        ['co'] = '@class.outer',
        ['ci'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']['] = '@function.outer',
        [']m'] = '@class.outer',
      },
      goto_next_end = {
        [']]'] = '@function.outer',
        [']M'] = '@class.outer',
      },
      goto_previous_start = {
        ['[['] = '@function.outer',
        ['[m'] = '@class.outer',
      },
      goto_previous_end = {
        ['[]'] = '@function.outer',
        ['[M'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<C-S-j>'] = '@parameter.inner',
      },
      swap_previous = {
        ['<C-S-k>'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = border,
      peek_definition_code = {
        ['<C-o>'] = '@function.outer',
      },
    },
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
  },
  context_commentstring = { enable = true },
  endwise = { enable = true },
}
require('nvim-treesitter.install').prefer_git = true
local parsers = require('nvim-treesitter.parsers').get_parser_configs()
for _, p in pairs(parsers) do
  p.install_info.url =
    p.install_info.url:gsub('https://githubfast.com/', 'git@github.com:')
end
