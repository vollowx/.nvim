return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      integrations = {
        alpha = false,
        dashboard = false,
        flash = false,
        illuminate = false,
        neogit = false,

        treesitter = true,
        native_lsp = { enabled = true },
        cmp = true,
        gitsigns = true,
        indent_blankline = { enabled = true, scope_color = 'surface2' },
        markdown = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = { enabled = true, style = 'nvchad' },
      },
      highlight_overrides = {
        all = function(cp) return { WinSeparator = { fg = cp.surface0 } } end,
      },
    },
  },

  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        options = {
          always_show_bufferline = false,
          indicator = { style = 'none' },
          separator_style = { '', '' },
          tab_size = 0,
          mode = 'tabs',
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_duplicate = false,
          enforce_regular_tabs = false,
        },
        highlights = require('catppuccin.groups.integrations.bufferline').get(),
      }
    end,
  },

  {
    'stevearc/dressing.nvim',
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        border = 'none',
      },
      select = {
        backend = 'builtin',
        builtin = {
          border = 'none',
          relative = 'cursor',
          min_height = { 0, 0 },
        },
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'LazyFile',
    opts = {
      indent = { char = '▏' },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },

  {
    'utilyre/sentiment.nvim',
    event = 'VeryLazy',
    init = function() vim.g.loaded_matchparen = 1 end,
    opts = { delay = 0 },
  },

  {
    'echasnovski/mini.bufremove',
    keys = {
      {
        'sd',
        function() require('mini.bufremove').delete() end,
      },
    },
  },
}
