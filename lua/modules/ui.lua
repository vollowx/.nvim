return {
  {
    'NvChad/nvim-colorizer.lua',
    enabled = vim.g.gui,
    event = { 'BufNew', 'BufRead' },
    configs = function() require 'configs.colorizer' end,
  },

  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufWritePost' },
    config = function() require 'configs.dropbar' end,
  },
}
