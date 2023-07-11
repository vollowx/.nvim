local map = require('utils').keymap.set

-- Override keymaps in core.keymaps
map('n', '<A-q>', function() require('cokeline.buffers').get_current():delete() end, { desc = 'buffer: Delete buffer' })
map('n', '<A-j>', '<Plug>(cokeline-focus-next)', { desc = 'buffer: Next buffer' })
map('n', '<A-k>', '<Plug>(cokeline-focus-prev)', { desc = 'buffer: Previous buffer' })

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
