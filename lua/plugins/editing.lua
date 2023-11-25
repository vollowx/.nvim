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
    opts = {},
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
    event = 'InsertEnter',
    opts = {
      panel = {
        auto_refresh = true,
      },
      suggestion = {
        auto_trigger = true,
      },
    },
  },
}
