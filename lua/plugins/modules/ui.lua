local map = require('utils').keymap.set

-- Override keymaps in core.keymaps
map('n', '<A-q>', '<Cmd>bdelete!<CR>', { desc = 'buffer: Delete current buffer' })
map('n', '<A-j>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'buffer: Switch to next buffer' })
map('n', '<A-k>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'buffer: Switch to previous buffer' })
map('n', '<A-S-j>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'buffer: Move buffer to next' })
map('n', '<A-S-k>', '<Cmd>BufferLineMovePrev<CR>', { desc = 'buffer: Move buffer to previous' })
map('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', { desc = 'buffer: Goto buffer 1' })
map('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', { desc = 'buffer: Goto buffer 2' })
map('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', { desc = 'buffer: Goto buffer 3' })
map('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', { desc = 'buffer: Goto buffer 4' })
map('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', { desc = 'buffer: Goto buffer 5' })
map('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', { desc = 'buffer: Goto buffer 6' })
map('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', { desc = 'buffer: Goto buffer 7' })
map('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', { desc = 'buffer: Goto buffer 8' })
map('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', { desc = 'buffer: Goto buffer 9' })

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
    'rcarriga/nvim-notify',
    lazy = false,
    config = function() require 'plugins.configs.notify' end,
  },
  {
    'dstein64/nvim-scrollview',
    lazy = false,
    config = function() require 'plugins.configs.scrollview' end,
    enabled = false,
  },
  {
    'akinsho/bufferline.nvim',
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function() require 'plugins.configs.bufferline' end,
  },
  {
    'Bekaboo/dropbar.nvim',
    event = 'User File',
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
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User File',
    config = function() require 'plugins.configs.indent-blankline' end,
  },
}
