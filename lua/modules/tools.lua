return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'plenary.nvim' },
    cmd = 'Telescope',
    config = function() require 'configs.telescope' end,
    keys = {
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'find: Files' },
      { '<Leader>fo', '<Cmd>Telescope oldfiles<CR>' },
      { '<Leader>fw', '<Cmd>Telescope live_grep<CR>' },
      { '<Leader>fb', '<Cmd>Telescope buffers<CR>' },
      { '<Leader>fh', '<Cmd>Telescope highlights<CR>' },
      { '<Leader>fc', '<Cmd>Telescope colorscheme<CR>' },

      { '<Leader>fe', '<Cmd>Telescope diagnostics<CR>' },

      { '<Leader>fgb', '<Cmd>Telescope git_branches<CR>' },
      { '<Leader>fgc', '<Cmd>Telescope git_commits<CR>' },
      { '<Leader>fgs', '<Cmd>Telescope git_status<CR>' },
    },
  },

  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function() require('telescope').load_extension 'file_browser' end,
    keys = {
      {
        '<Leader>fi',
        function()
          require('telescope').extensions.file_browser.file_browser {
            path = '%:p:h',
            cwd = vim.fn.expand '%:p:h',
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            quiet = true,
            dir_icon = vim.trim(PREF.icons.kinds.Folder),
          }
        end,
        desc = 'find: File browser',
      },
    },
  },

  {
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    keys = { { 'gq;', function() require('conform').format() end } },
    config = function() require 'configs.conform' end,
  },

  {
    'willothy/flatten.nvim',
    event = 'BufReadPre',
    config = function() require 'configs.flatten' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'plenary.nvim',
    event = 'BufReadPre',
    config = function() require 'configs.gitsigns' end,
    keys = {
      { ']g', '<Cmd>Gitsigns next_hunk<CR>' },
      { '[g', '<Cmd>Gitsigns prev_hunk<CR>' },
      { '<Leader>gl', '<Cmd>Gitsigns blame_line<CR>' },
      {
        '<Leader>gL',
        function() require('gitsigns').blame_line { full = true } end,
      },
      { '<Leader>gp', '<Cmd>Gitsigns preview_hunk<CR>' },
      { '<Leader>gs', '<Cmd>Gitsigns stage_hunk<CR>' },
      { '<Leader>gr', '<Cmd>Gitsigns reset_hunk<CR>' },
      { '<Leader>gS', '<Cmd>Gitsigns stage_buffer<CR>' },
      { '<Leader>gR', '<Cmd>Gitsigns reset_buffer<CR>' },
      { '<Leader>gu', '<Cmd>Gitsigns undo_stage_hunk<CR>' },
      { '<Leader>gd', '<Cmd>Gitsigns diffthis<CR>' },
      { 'ah', ':<C-u>Gitsigns select_hunk<CR>', mode = 'v' },
    },
  },

  { 'wakatime/vim-wakatime', event = 'BufReadPost' },
}
