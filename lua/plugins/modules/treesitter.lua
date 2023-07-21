local map = require('utils').keymap.set
map('n', '<Leader><Leader>', function() require('ts-node-action').node_action() end)

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
    config = function() require 'plugins.configs.nvim-treesitter' end,
    dependencies = {
      'nvim-treesitter-textobjects',
      'nvim-ts-context-commentstring',
      'nvim-treesitter-endwise',
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter',
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = 'nvim-treesitter',
  },

  {
    'CKolkey/ts-node-action',
    event = 'User File',
    dependencies = 'nvim-treesitter',
    config = function() require 'plugins.configs.ts-node-action' end,
  },

  -- Will break startup screen texts
  {
    'Eandrju/cellular-automaton.nvim',
    cmd = 'CellularAutomaton',
    dependencies = 'nvim-treesitter',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    dependencies = 'nvim-treesitter',
  },
}
