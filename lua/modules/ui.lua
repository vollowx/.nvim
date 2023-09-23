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
    branch = 'v3',
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
}
