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
    'junegunn/vim-easy-align',
    keys = {
      { 'gl', mode = { 'n', 'x' } },
      { 'gL', mode = { 'n', 'x' } },
    },
    config = function() require 'configs.vim-easy-align' end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'VeryLazy',
    config = function() require 'configs.copilot' end,
  },
}
