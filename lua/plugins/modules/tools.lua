local map = require('utils').keymap.set

-- stylua: ignore start
map('n', '<C-p>', '<Cmd>Telescope keymaps<CR>', { desc = 'ui: Open command panel' })
map('n', '<Leader>F', '<Cmd>Telescope builtin<CR>', { desc = 'find: Finders' })
map('n', '<Leader>ff', '<Cmd>Telescope find_files<CR>', { desc = 'find: Files' })
map('n', '<Leader>fo', '<Cmd>Telescope oldfiles<CR>', { desc = 'find: Recent files' })
map('n', '<Leader>fw', '<Cmd>Telescope live_grep<CR>', { desc = 'find: Words' })
map('n', '<Leader>fb', '<Cmd>Telescope buffers<CR>', { desc = 'find: Buffers' })
map('n', '<Leader>fe', '<Cmd>Telescope diagnostics<CR>', { desc = 'find: Diagnostics' })
map('n', '<Leader>fr', '<Cmd>Telescope lsp_references<CR>', { desc = 'find: LSP references' })
map('n', '<Leader>fd', '<Cmd>Telescope lsp_definitions<CR>', { desc = 'find: LSP definitions' })
map('n', '<Leader>fg', '<Cmd>Telescope git_status<CR>', { desc = 'find: Git status' })
map('n', '<Leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = 'find: Help pages' })
map('n', '<Leader>fm', '<Cmd>Telescope marks<CR>', { desc = 'find: Marks' })
map('n', '<Leader>fc', '<Cmd>Telescope colorscheme<CR>', { desc = 'find: Color-Schemes' })
map('n', '<Leader>fu', '<Cmd>Telescope undo<CR>', { desc = 'find: Undoes' })
map('n', '<Leader>fn', '<Cmd>Telescope notify<CR>', { desc = 'find: Notifications' })
-- stylua: ignore end

map('tn', '<A-d>', '<cmd>ToggleTerm direction=float<cr>', { desc = 'terminal: Toggle floating' })
map('tn', '<A-\\>', '<cmd>ToggleTerm direction=vertical<cr>', { desc = 'terminal: Toggle vertical' })
map('tn', '<A-e>', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = 'terminal: Toggle horizontal' })
map('tn', '<A-g>', '<Cmd>Lazygit<CR>', { desc = 'terminal: Toggle LazyGit' })

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'plenary.nvim',
      'telescope-undo.nvim',
    },
    config = function() require 'plugins.configs.telescope' end,
  },

  {
    'debugloop/telescope-undo.nvim',
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'willothy/flatten.nvim',
    lazy = false,
    config = function() require 'plugins.configs.flatten' end,
  },

  {
    'akinsho/toggleterm.nvim',
    cmd = {
      'Lazygit',
      'TermExec',
      'ToggleTerm',
      'ToggleTermSetName',
      'ToggleTermToggleAll',
      'ToggleTermSendCurrentLine',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = function() require 'plugins.configs.toggleterm' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'User GitFile',
    dependencies = 'plenary.nvim',
    config = function() require 'plugins.configs.gitsigns' end,
  },

  {
    'akinsho/git-conflict.nvim',
    event = 'User GitFile',
    config = function() require 'plugins.configs.git-conflict' end,
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    config = function() require 'plugins.configs.flash' end,
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'flash: Jump' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'flash: Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'flash: Remote' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'flash: Treesitter search' },
      { '<C-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'flash: Toggle search' },
    },
  },
}
