return {
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufNew', 'BufRead' },
    configs = function() require 'packages._.colorizer' end,
  },

  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufWritePost' },
    config = function() require 'packages._.dropbar' end,
  }
}
