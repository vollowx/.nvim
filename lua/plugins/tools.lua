return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'find: Files' },
      { '<Leader>fo', '<Cmd>Telescope oldfiles<CR>' },
      { '<Leader>fw', '<Cmd>Telescope live_grep<CR>' },
      { '<Leader>fb', '<Cmd>Telescope buffers<CR>' },
      { '<Leader>fh', '<Cmd>Telescope help_tags<CR>' },
      { '<Leader>fc', '<Cmd>Telescope colorscheme<CR>' },

      { '<Leader>fe', '<Cmd>Telescope diagnostics<CR>' },

      { '<Leader>fgb', '<Cmd>Telescope git_branches<CR>' },
      { '<Leader>fgc', '<Cmd>Telescope git_commits<CR>' },
      { '<Leader>fgs', '<Cmd>Telescope git_status<CR>' },
    },
    config = function()
      local telescope = require 'telescope'

      local rg_cmd = {
        'rg',
        '--hidden',
        '--vimgrep',
        '--column',
        '--line-number',
        '--smart-case',
        '--with-filename',
        '--no-heading',
        '--color=never',
      }

      local fd_cmd = {
        'fd',
        '-p',
        '-H',
        '-L',
        '-tf',
        '-tl',
        '-d10',
        '--mount',
        '-c=never',
      }

      -- Dropdown layout for telescope
      local layout_dropdown = {
        previewer = false,
        layout_config = {
          width = 0.6,
          height = 0.65,
        },
      }

      telescope.setup {
        defaults = {
          mappings = { i = { ['<Esc>'] = require('telescope.actions').close } },
          prompt_prefix = '/ ',
          selection_caret = PREF.icons.ui.ArrowRight,
          results_title = false,
          layout_strategy = 'flex',
          layout_config = {
            width = 0.8,
            height = 0.8,
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
            },
            vertical = {
              prompt_position = 'top',
              mirror = true,
            },
          },
          sorting_strategy = 'ascending',
          vimgrep_arguments = rg_cmd,
        },
        pickers = {
          colorscheme = { enable_preview = true },
          find_files = { find_command = fd_cmd },
          keymaps = layout_dropdown,
          live_grep = { additional_args = { '--hidden' } },
          lsp_references = { include_current_line = true, jump_type = 'never' },
          lsp_definitions = { jump_type = 'never' },
          lsp_type_definitions = { jump_type = 'never' },
          spell_suggest = layout_dropdown,
        },
      }
    end,
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
            dir_icon = vim.trim(PREF.icons.kinds.Folder),
            grouped = true,
            hijack_netrw = true,
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
    opts = { formatters_by_ft = PREF.formatters },
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'plenary.nvim',
    event = 'BufReadPost',
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
    opts = {
      preview_config = {
        border = PREF.ui.hover_border,
        style = 'minimal',
      },
      signs = {
        add = { text = '▍' },
        untracked = { text = '▍' },
        change = { text = '▍' },
        delete = { text = '▁' },
        topdelete = { text = '▔' },
        changedelete = { text = '▍' },
      },
      signcolumn = PREF.git.show_signcolumn,
      current_line_blame = PREF.git.show_blame,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
      },
    },
  },

  { 'wakatime/vim-wakatime', event = 'BufReadPost' },
}
