return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = {
      'TSInstall',
      'TSInstallSync',
      'TSInstallInfo',
      'TSUninstall',
      'TSUpdate',
      'TSUpdateSync',
      'TSBufEnable',
      'TSBufToggle',
      'TSEnable',
      'TSToggle',
      'TSModuleInfo',
      'TSEditQuery',
      'TSEditQueryUserAfter',
    },
    event = 'User File',
    config = function() require 'configs.nvim-treesitter' end,
    dependencies = {
      -- 'nvim-treesitter-context',
      'nvim-treesitter-textobjects',
      'nvim-ts-context-commentstring',
      'nvim-treesitter-endwise',
      'nvim-ts-autotag',
      'ts-node-action',
    },
  },

  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   dependencies = 'nvim-treesitter',
  --   config = function() require 'configs.ts-context' end,
  -- },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter',
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
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter',
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
    'Eandrju/cellular-automaton.nvim',
    cmd = 'CellularAutomaton',
    dependencies = 'nvim-treesitter',
  },
}
