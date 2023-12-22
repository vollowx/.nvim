return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter-endwise' },
    build = ':TSUpdate',
    init = function(plugin)
      require('lazy.core.loader').add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    config = function() require 'configs.nvim-treesitter' end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    event = { 'LazyFile', 'VeryLazy' },
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
    event = 'LazyFile',
    opts = {},
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'LazyFile',
    opts = { enable_autocmd = false },
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'LazyFile',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    dependencies = 'nvim-treesitter',
  },
}
