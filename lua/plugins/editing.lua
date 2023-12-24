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
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('Comment').setup {
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
      }
    end,
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {},
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'gl', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
      { 'gL', '<Plug>(LiveEasyAlign)', mode = { 'n', 'x' } },
    },
    config = function()
      vim.g.easy_align_delimiters = {
        ['\\'] = {
          pattern = [[\\\+]],
        },
        ['/'] = {
          pattern = [[//\+\|/\*\|\*/]],
          delimiter_align = 'c',
          ignore_groups = '!Comment',
        },
      }
    end,
  },
}
