local map = require('utils').keymap.set
map('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', { desc = 'ui: Toggle file tree' })

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function() require 'plugins.configs.catppuccin' end,
    lazy = false,
  },
  {
    'willothy/nvim-cokeline',
    event = 'BufEnter',
    config = function() require 'plugins.configs.cokeline' end,
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
  },
  {
    'Bekaboo/deadcolumn.nvim',
    event = 'BufEnter',
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User NvFile',
    config = function() require 'plugins.configs.indent-blankline' end,
  },
}
