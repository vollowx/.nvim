return {
  {
    'numToStr/Comment.nvim',
    config = function() require 'configs.Comment' end,
    keys = {
      { 'gc', mode = { 'n', 'x' }, desc = 'comment: Toggle lines' },
      { 'gb', mode = { 'n', 'x' }, desc = 'comment: Toggle block' },
    },
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function() require 'configs.ultimate-autopair' end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'VeryLazy',
    config = function() require 'configs.copilot' end,
  },
}
