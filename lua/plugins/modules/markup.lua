return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown' },
    config = function() require 'plugins.configs.vimtex' end,
  },

  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    ft = 'markdown',
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    event = 'User NvFile',
    config = function() require 'plugins.configs.vim-table-mode' end,
  },
}
