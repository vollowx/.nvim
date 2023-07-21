local map = require('utils').keymap.set

-- Override keymaps in core.keymaps
-- map('n', '<A-q>', function() require('cokeline.buffers').get_current():delete() end, { desc = 'buffer: Delete buffer' })
-- map('n', '<A-j>', '<Plug>(cokeline-focus-next)', { desc = 'buffer: Next buffer' })
-- map('n', '<A-k>', '<Plug>(cokeline-focus-prev)', { desc = 'buffer: Previous buffer' })

map('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', { desc = 'ui: Toggle file tree' })

map('n', '<Leader>;', function() require('dropbar.api').pick() end)
map('n', '[C', function() require('dropbar.api').goto_context_start() end)
map('n', ']C', function() require('dropbar.api').select_next_context() end)

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
    'Bekaboo/dropbar.nvim',
    lazy = false,
    config = function() require 'plugins.configs.dropbar' end,
  },
  {
    'dstein64/nvim-scrollview',
    lazy = false,
    config = function() require 'plugins.configs.scrollview' end,
  },
  {
    'rcarriga/nvim-notify',
    lazy = false,
    config = function() require 'plugins.configs.notify' end,
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
    'lukas-reineke/indent-blankline.nvim',
    event = 'User File',
    config = function() require 'plugins.configs.indent-blankline' end,
  },
}
