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
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = 'light'
    end,
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    event = 'User NvFile',
    config = function() require 'plugins.configs.vim-table-mode' end,
  },
}
