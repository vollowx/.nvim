return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function() require 'configs.catppuccin' end,
    lazy = false,
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.dressing' end,
  },
  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufWritePost' },
    config = function() require 'configs.dropbar' end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.indent-blankline' end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = function() require 'configs.colorizer' end,
  },

  {
    'ojroques/nvim-bufdel',
    cmd = { 'BufDel', 'BufDelAll', 'BufDelOthers' },
    keys = {
      { '<A-q>', '<Cmd>BufDel<CR>', desc = 'buffer: Delete current' },
      { '<A-S-q>', '<Cmd>BufDel!<CR>', desc = 'buffer: Force delete current' },
    },
  },

  {
    'yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    config = function() require 'configs.pqf' end,
  },

  {
    'utilyre/sentiment.nvim',
    event = 'VeryLazy',
    init = function() vim.g.loaded_matchparen = 1 end,
    config = function() require 'configs.sentiment' end,
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.scrollEOF' end,
  },
}
