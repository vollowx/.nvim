return {
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'ds',
      'cs',
      { 'S', mode = 'x' },
      { '<C-g>s', mode = 'i' },
    },
    config = function() require 'plugins.configs.nvim-surround' end,
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' }, desc = 'comment: toggle lines' },
      { 'gb', mode = { 'n', 'x' }, desc = 'comment: toggle block' },
    },
    config = function() require 'plugins.configs.Comment' end,
  },

  {
    'tpope/vim-sleuth',
    event = 'User File',
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function() require 'plugins.configs.nvim-autopairs' end,
  },
}
