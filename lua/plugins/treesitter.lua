return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function() require 'configs.nvim-treesitter' end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    event = { 'LazyFile', 'VeryLazy' },
    dependencies = {
      'ts-node-action',
      'nvim-ts-autotag',
      'nvim-ts-context-commentstring',
      'nvim-treesitter-context',
      'nvim-treesitter-endwise',
      'nvim-treesitter-textobjects',
      'rainbow-delimiters.nvim',
    },
  },

  {
    'CKolkey/ts-node-action',
    dependencies = 'nvim-treesitter',
    config = function() require 'configs.ts-node-action' end,
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
    dependencies = 'nvim-treesitter',
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = 'nvim-treesitter',
    config = function() require 'configs.ts-context' end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = 'nvim-treesitter',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    dependencies = 'nvim-treesitter',
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter',
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = 'nvim-treesitter',
  },
}
