return {
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufNew', 'BufRead' },
    configs = function() require 'packages._.colorizer' end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function() require 'packages._.ibl' end,
  },

  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufWritePost' },
    config = function() require 'packages._.dropbar' end,
  }
}
