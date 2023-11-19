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
        dropbar = { enabled = true, color_mode = true },
        gitsigns = true,
        indent_blankline = { enabled = true, scope_color = 'surface2' },
        markdown = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = { enabled = true, style = 'nvchad' },
      },
      highlight_overrides = {
        all = function(cp)
          return {
            -- For base configs
            None = { bg = cp.none },
            WinSeparator = { fg = cp.surface0 },
            TabLine = { bg = cp.crust, fg = cp.overlay0 },
            TabLineFill = { bg = cp.crust },
            TabLineSel = { bg = cp.base, fg = cp.text },

            -- For telescope.nvim
            TelescopePromptNormal = { bg = cp.crust },
            TelescopePromptBorder = {
              fg = cp.crust,
              bg = cp.crust,
            },
            TelescopePromptPrefix = { bg = cp.crust },

            -- For status line
            StatusLineDiagnosticError = { fg = cp.red, bg = cp.mantle },
            StatusLineDiagnosticWarn = { fg = cp.yellow, bg = cp.mantle },
            StatusLineDiagnosticInfo = { fg = cp.blue, bg = cp.mantle },
            StatusLineDiagnosticHint = { fg = cp.teal, bg = cp.mantle },
            StatusLineFaded = { fg = cp.subtext0, bg = cp.mantle },
            StatusLineGitAdded = { fg = cp.green, bg = cp.mantle },
            StatusLineGitChanged = { fg = cp.blue, bg = cp.mantle },
            StatusLineGitRemoved = { fg = cp.red, bg = cp.mantle },
            StatusLineHeader = { fg = cp.lavender, bg = cp.surface0 },
            StatusLineHeaderModified = { fg = cp.pink, bg = cp.surface0 },
            StatusLineStrong = {
              fg = cp.text,
              bg = cp.mantle,
              style = { 'bold' },
            },
          }
        end,
      },
    },
  },

  {
    'akinsho/bufferline.nvim',
    dir = '~/Documents/Development/bufferline.nvim/',
    event = 'VeryLazy',
    keys = {
      { 'H', '<Cmd>BufferLineCyclePrev<CR>' },
      { 'L', '<Cmd>BufferLineCycleNext<CR>' },
      { '<M-S-1>', '<Cmd>ScopeMoveBuf 1<CR>' },
      { '<M-S-2>', '<Cmd>ScopeMoveBuf 2<CR>' },
      { '<M-S-3>', '<Cmd>ScopeMoveBuf 3<CR>' },
      { '<M-S-4>', '<Cmd>ScopeMoveBuf 4<CR>' },
      { '<M-S-5>', '<Cmd>ScopeMoveBuf 5<CR>' },
      { '<M-S-6>', '<Cmd>ScopeMoveBuf 6<CR>' },
      { '<M-S-7>', '<Cmd>ScopeMoveBuf 7<CR>' },
      { '<M-S-8>', '<Cmd>ScopeMoveBuf 8<CR>' },
      { '<M-S-9>', '<Cmd>ScopeMoveBuf 9<CR>' },
    },
    opts = function()
      return {
        options = {
          always_show_bufferline = false,
          indicator = { style = 'none' },
          separator_style = { '', '' },
          tab_size = 20,
        },
        highlights = require('catppuccin.groups.integrations.bufferline').get(),
      }
    end,
  },
  {
    'tiagovla/scope.nvim',
    event = 'VeryLazy',
    opts = {},
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
        border = 'shadow',
      },
      select = {
        backend = 'builtin',
        builtin = {
          border = 'shadow',
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
    'yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'utilyre/sentiment.nvim',
    event = 'VeryLazy',
    init = function() vim.g.loaded_matchparen = 1 end,
    opts = {},
  },
}
