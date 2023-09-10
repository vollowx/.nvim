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
    config = function() require 'configs.nvim-surround' end,
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' }, desc = 'comment: Toggle lines' },
      { 'gb', mode = { 'n', 'x' }, desc = 'comment: Toggle block' },
    },
    config = function() require 'configs.Comment' end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function() require 'configs.nvim-autopairs' end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = { 'CursorHold', 'CursorHoldI' },
    config = function() require 'configs.copilot' end,
  },
}
