return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function() require 'plugins.configs.catppuccin' end,
    lazy = false,
  },

  -- Unchangeable UI components
  {
    'Bekaboo/deadcolumn.nvim',
    lazy = false,
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function() require 'plugins.configs.dressing' end,
  },
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function() require 'plugins.configs.notify' end,
  },
  {
    'Bekaboo/dropbar.nvim',
    event = 'VeryLazy', -- For stable UI layout
    config = function() require 'plugins.configs.dropbar' end,
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
    config = function() require 'plugins.configs.nvim-tree' end,
    keys = {
      { '<C-n>', '<Cmd>NvimTreeToggle<CR>', desc = 'ui: Toggle file tree' },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User File',
    config = function() require 'plugins.configs.indent-blankline' end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'User File',
    config = function() require 'plugins.configs.colorizer' end,
  },
}
