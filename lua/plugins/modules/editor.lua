local map = require('utils').keymap.set

map('nx', 'gea', '<Cmd>EasyAlign<CR>', { desc = 'edit: Align with delimiter' })

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
      { 'gc', mode = { 'n', 'x' } },
      { 'gb', mode = { 'n', 'x' } },
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

  {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    config = function() require 'plugins.configs.vim-easy-align' end,
  },
}
