return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'RRethy/nvim-treesitter-endwise' },
    build = ':TSUpdateSync',
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    event = 'BufReadPre',
    opts = {
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
    },
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
  },

  {
    'CKolkey/ts-node-action',
    keys = {
      {
        '<Leader><Leader>',
        function() require('ts-node-action').node_action() end,
        desc = 'treesitter: Do node action',
      },
    },
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'BufReadPre',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {},
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    opts = { max_lines = 3 },
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPre',
  },
}
