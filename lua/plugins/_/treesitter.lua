require('nvim-treesitter.configs').setup {
  auto_install = true,
  modules = {},
  ignore_install = {},
  ensure_installed = PREF.treesitter,
  sync_install = false,
  highlight = {
    enable = true,
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
