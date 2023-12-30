return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'RRethy/nvim-treesitter-endwise' },
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
    event = 'FileType',
    config = function()
      vim.schedule(function() require 'plugins._.treesitter' end)
    end,
  },

  {
    'CKolkey/ts-node-action',
    dependencies = 'nvim-treesitter/nvim-treesitter',
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
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'FileType',
    config = function() require 'plugins._.ts-autotag' end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'FileType',
  },
}
