local icons = require('utils.static').icons

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'plenary.nvim' },
    config = function() require 'configs.telescope' end,
    cmd = 'Telescope',
    keys = {
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'find: Files' },
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
        '<Leader>fe',
        '<Cmd>Telescope diagnostics<CR>',
        desc = 'find: Diagnostics',
      },

      {
        '<Leader>fgb',
        '<Cmd>Telescope git_branches<CR>',
        desc = 'find: Git branches',
      },
      {
        '<Leader>fgc',
        '<Cmd>Telescope git_commits<CR>',
        desc = 'find: Git commits',
      },
      {
        '<Leader>fgs',
        '<Cmd>Telescope git_status<CR>',
        desc = 'find: Git status',
      },
    },
  },

  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'telescope.nvim' },
    config = function() require('telescope').load_extension 'file_browser' end,
    keys = {
      {
        '<Leader>fi',
        function()
          require('telescope').extensions.file_browser.file_browser {
            dir_icon = vim.trim(icons.kinds.Folder),
            grouped = true,
            hijack_netrw = true,
          }
        end,
        desc = 'find: File browser',
      },
    },
  },

  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = { 'telescope.nvim' },
    config = function() require('telescope').load_extension 'frecency' end,
    keys = {
      { '<Leader>fo', '<Cmd>Telescope frecency<CR>', desc = 'find: Frecency' },
    },
  },

  {
    'stevearc/conform.nvim',
    config = function() require 'configs.conform' end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.autoformat = true
      vim.api.nvim_create_user_command('AutoFormatDisable', function(args)
        if args.bang then
          vim.g.autoformat = false
        else
          vim.b.autoformat = false
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      vim.api.nvim_create_user_command('AutoFormatEnable', function()
        vim.b.autoformat = true
        vim.g.autoformat = true
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
    cmd = { 'ConformInfo' },
    event = 'BufWritePre',
  },

  {
    'folke/todo-comments.nvim',
    dependencies = 'plenary.nvim',
    opts = {
      keywords = {
        FIX = {
          icon = icons.ui.Bug,
          color = 'error',
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
        },
        TODO = { icon = icons.ui.Check, color = 'info' },
        HACK = { icon = icons.ui.Ghost, color = 'warning' },
        WARN = {
          icon = icons.diagnostics.Warn,
          color = 'warning',
          alt = { 'WARNING', 'XXX' },
        },
        PERF = {
          icon = icons.ui.ClockFast,
          alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' },
        },
        NOTE = { icon = icons.ui.Note, color = 'hint', alt = { 'INFO' } },
        TEST = {
          icon = icons.ui.Flag,
          color = 'test',
          alt = { 'TESTING', 'PASSED', 'FAILED' },
        },
      },
    },
    event = 'VeryLazy',
    cmd = { 'TodoLocList', 'TodoQuickFix', 'TodoTelescope' },
    keys = {
      { '<Leader>ft', '<Cmd>TodoTelescope<CR>', desc = 'find: Todos' },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'plenary.nvim',
    event = 'LazyFile',
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
    opts = {
      preview_config = {
        border = 'shadow',
        style = 'minimal',
      },
      signs = {
        add = { text = '┃' },
        untracked = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '▁' },
        topdelete = { text = '▔' },
        changedelete = { text = '╋' },
      },
      _extmark_signs = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 100,
      },
    },
  },

  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
}
