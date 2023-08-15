return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function() require 'configs.catppuccin' end,
    lazy = false,
  },

  {
    'Bekaboo/deadcolumn.nvim',
    lazy = false,
  },
  {
    'stevearc/dressing.nvim',
    event = { 'CursorHold', 'CursorHoldI' },
    config = function() require 'configs.dressing' end,
  },
  {
    'rcarriga/nvim-notify',
    event = { 'CursorHold', 'CursorHoldI' },
    config = function() require 'configs.notify' end,
  },
  {
    'Bekaboo/dropbar.nvim',
    event = { 'CursorHold', 'CursorHoldI' },
    config = function() require 'configs.dropbar' end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    cmd = {
      'NvimTreeOpen',
      'NvimTreeClose',
      'NvimTreeToggle',
      'NvimTreeFocus',
      'NvimTreeRefresh',
      'NvimTreeFindFile',
      'NvimTreeFindFileToggle',
      'NvimTreeClipboard',
      'NvimTreeResize',
      'NvimTreeCollapse',
      'NvimTreeCollapseKeepBuffers',
      'NvimTreeGenerateOnAttach',
    },
    config = function() require 'configs.nvim-tree' end,
    keys = {
      { '<C-n>', '<Cmd>NvimTreeToggle<CR>', desc = 'ui: Toggle file tree' },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User File',
    config = function() require 'configs.indent-blankline' end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'User File',
    config = function() require 'configs.colorizer' end,
  },

  -- You're not able to see this actually, but it controls the UI
  {
    'ojroques/nvim-bufdel',
    cmd = {
      'BufDel',
      'BufDelAll',
      'BufDelOthers',
    },
    keys = {
      { '<A-q>', '<Cmd>BufDel<CR>', desc = 'buffer: Delete current' },
      { '<A-S-q>', '<Cmd>BufDel!<CR>', desc = 'buffer: Force delete current' },
    },
  },
}
