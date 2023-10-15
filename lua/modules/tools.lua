return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'plenary.nvim',
      'telescope-undo.nvim',
    },
    config = function() require 'configs.telescope' end,
    cmd = 'Telescope',
    keys = {
      { '<Leader>f', '<Cmd>Telescope builtin<CR>', desc = 'find: Finders' },
      { '<Leader>F', '<Cmd>Telescope builtin<CR>', desc = 'find: Finders' },
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'find: Files' },
      {
        '<Leader>fo',
        '<Cmd>Telescope oldfiles<CR>',
        desc = 'find: Recent files',
      },
      { '<Leader>fw', '<Cmd>Telescope live_grep<CR>', desc = 'find: Words' },
      { '<Leader>fb', '<Cmd>Telescope buffers<CR>', desc = 'find: Buffers' },
      {
        '<Leader>fk',
        '<Cmd>Telescope keymaps<CR>',
        desc = 'find: Key-mappings',
      },
      {
        '<Leader>fh',
        '<Cmd>Telescope help_tags<CR>',
        desc = 'find: Help pages',
      },
      {
        '<Leader>fc',
        '<Cmd>Telescope colorscheme<CR>',
        desc = 'find: Color-Schemes',
      },
      {
        '<Leader>fg',
        '<Cmd>Telescope git_status<CR>',
        desc = 'find: Git status',
      },

      {
        '<Leader>fe',
        '<Cmd>Telescope diagnostics<CR>',
        desc = 'find: Diagnostics',
      },
      {
        '<Leader>fr',
        '<Cmd>Telescope lsp_references<CR>',
        desc = 'find: LSP references',
      },
      {
        '<Leader>fd',
        '<Cmd>Telescope lsp_definitions<CR>',
        desc = 'find: LSP definitions',
      },
      {
        '<Leader>fs',
        '<Cmd>Telescope lsp_document_symbols<CR>',
        desc = 'find: LSP document symbols',
      },

      { '<Leader>fu', '<Cmd>Telescope undo<CR>', desc = 'find: Undoes' },
      {
        '<Leader>fn',
        '<Cmd>Telescope notify<CR>',
        desc = 'find: Notifications',
      },
    },
  },

  {
    'debugloop/telescope-undo.nvim',
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'folke/todo-comments.nvim',
    dependencies = 'plenary.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.todo-comments' end,
    cmd = { 'TodoLocList', 'TodoQuickFix', 'TodoTelescope' },
    keys = {
      { '<Leader>ft', '<Cmd>TodoTelescope<CR>', desc = 'find: Todos' },
    },
  },

  {
    'willothy/flatten.nvim',
    event = 'BufReadPre',
    config = function() require 'configs.flatten' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'plenary.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.gitsigns' end,
    keys = {
      { ']g', '<Cmd>Gitsigns next_hunk<CR>', desc = 'git: Next hunk' },
      { '[g', '<Cmd>Gitsigns prev_hunk<CR>', desc = 'git: Previous hunk' },
      {
        '<Leader>gl',
        '<Cmd>Gitsigns blame_line<CR>',
        desc = 'git: View blame',
      },
      {
        '<Leader>gL',
        function() require('gitsigns').blame_line { full = true } end,
        desc = 'git: View full blame',
      },
      {
        '<Leader>gp',
        '<Cmd>Gitsigns preview_hunk<CR>',
        desc = 'git: Preview hunk',
      },
      {
        '<Leader>gs',
        '<Cmd>Gitsigns stage_hunk<CR>',
        desc = 'git: Stage hunk',
      },
      {
        '<Leader>gh',
        '<Cmd>Gitsigns reset_hunk<CR>',
        desc = 'git: Reset hunk',
      },
      {
        '<Leader>gS',
        '<Cmd>Gitsigns stage_buffer<CR>',
        desc = 'git: Stage buffer',
      },
      {
        '<Leader>gr',
        '<Cmd>Gitsigns reset_buffer<CR>',
        desc = 'git: Reset buffer',
      },
      {
        '<Leader>gu',
        '<Cmd>Gitsigns undo_stage_hunk<CR>',
        desc = 'git: Undo stage hunk',
      },
      { '<Leader>gd', '<Cmd>Gitsigns diffthis<CR>', desc = 'git: View diff' },
      {
        'ah',
        ':<C-u>Gitsigns select_hunk<CR>',
        mode = 'v',
        desc = 'git: Select hunk',
      },
    },
  },

  {
    'kevinhwang91/rnvimr',
    config = function() require 'configs.rnvimr' end,
    keys = {
      {
        '<M-e>',
        function() require('configs.rnvimr').toggle() end,
        desc = 'ui: Toggle file tree',
        mode = { 'n', 't' },
      },
    },
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
    'Aasim-A/scrollEOF.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.scrollEOF' end,
  },

  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
}
