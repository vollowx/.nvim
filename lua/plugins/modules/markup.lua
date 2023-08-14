return {
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    ft = 'markdown',
  },

  {
    'dhruvasagar/vim-table-mode',
    ft = 'markdown',
    config = function() require 'plugins.configs.vim-table-mode' end,
  },
}
