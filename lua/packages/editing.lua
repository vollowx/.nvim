return {
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre' },
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
      },
    },
    config = function() require 'packages._.comment' end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function() require 'packages._.autopairs' end,
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'gl', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
      { 'gL', '<Plug>(LiveEasyAlign)', mode = { 'n', 'x' } },
    },
    config = function() require 'packages._.easy-align' end,
  },
}
