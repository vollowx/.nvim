return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'plenary.nvim',
      'telescope-undo.nvim',
    },
    config = function() require 'configs.telescope' end,
    keys = {
      { '<C-p>', '<Cmd>Telescope keymaps<CR>', desc = 'ui: Open command panel' },
      { '<Leader>F', '<Cmd>Telescope builtin<CR>', desc = 'find: Finders' },
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'find: Files' },
      { '<Leader>fo', '<Cmd>Telescope oldfiles<CR>', desc = 'find: Recent files' },
      { '<Leader>fw', '<Cmd>Telescope live_grep<CR>', desc = 'find: Words' },
      { '<Leader>fb', '<Cmd>Telescope buffers<CR>', desc = 'find: Buffers' },
      { '<Leader>fe', '<Cmd>Telescope diagnostics<CR>', desc = 'find: Diagnostics' },
      { '<Leader>fr', '<Cmd>Telescope lsp_references<CR>', desc = 'find: LSP references' },
      { '<Leader>fd', '<Cmd>Telescope lsp_definitions<CR>', desc = 'find: LSP definitions' },
      { '<Leader>fg', '<Cmd>Telescope git_status<CR>', desc = 'find: Git status' },
      { '<Leader>fh', '<Cmd>Telescope help_tags<CR>', desc = 'find: Help pages' },
      { '<Leader>fm', '<Cmd>Telescope marks<CR>', desc = 'find: Marks' },
      { '<Leader>fc', '<Cmd>Telescope colorscheme<CR>', desc = 'find: Color-Schemes' },
      { '<Leader>fu', '<Cmd>Telescope undo<CR>', desc = 'find: Undoes' },
      { '<Leader>fn', '<Cmd>Telescope notify<CR>', desc = 'find: Notifications' },
    },
  },

  {
    'debugloop/telescope-undo.nvim',
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
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
    config = function() require 'configs.toggleterm' end,
    keys = {
      { '<A-i>', '<Cmd>ToggleTerm direction=float<CR>', mode = { 'n', 't' }, desc = 'terminal: Toggle floating' },
      { '<A-v>', '<Cmd>ToggleTerm direction=vertical<CR>', mode = { 'n', 't' }, desc = 'terminal: Toggle vertical' },
      {
        '<A-h>',
        '<Cmd>ToggleTerm direction=horizontal<CR>',
        mode = { 'n', 't' },
        desc = 'terminal: Toggle horizontal',
      },
      { '<A-g>', '<Cmd>Lazygit<CR>', mode = { 'n', 't' }, desc = 'terminal: Toggle LazyGit' },
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'User File',
    dependencies = 'plenary.nvim',
    config = function() require 'configs.todo-comments' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'User GitFile',
    dependencies = 'plenary.nvim',
    config = function() require 'configs.gitsigns' end,
    keys = {
      { ']g', '<Cmd>Gitsigns next_hunk<CR>', desc = 'git: Next hunk' },
      { '[g', '<Cmd>Gitsigns prev_hunk<CR>', desc = 'git: Previous hunk' },
      { '<Leader>gl', '<Cmd>Gitsigns blame_line<CR>', desc = 'git: View blame' },
      { '<Leader>gL', function() require('gitsigns').blame_line { full = true } end, desc = 'git: View full blame' },
      { '<Leader>gp', '<Cmd>Gitsigns preview_hunk<CR>', desc = 'git: Preview hunk' },
      { '<Leader>gs', '<Cmd>Gitsigns stage_hunk<CR>', desc = 'git: Stage hunk' },
      { '<Leader>gh', '<Cmd>Gitsigns reset_hunk<CR>', desc = 'git: Reset hunk' },
      { '<Leader>gS', '<Cmd>Gitsigns stage_buffer<CR>', desc = 'git: Stage buffer' },
      { '<Leader>gr', '<Cmd>Gitsigns reset_buffer<CR>', desc = 'git: Reset buffer' },
      { '<Leader>gu', '<Cmd>Gitsigns undo_stage_hunk<CR>', desc = 'git: Undo stage hunk' },
      { '<Leader>gd', '<Cmd>Gitsigns diffthis<CR>', desc = 'git: View diff' },
      { 'ah', ':<C-u>Gitsigns select_hunk<CR>', desc = 'git: Select hunk' },
    },
  },

  {
    'akinsho/git-conflict.nvim',
    event = 'User GitFile',
    config = function() require 'configs.git-conflict' end,
  },
}
