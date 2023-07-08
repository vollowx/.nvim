local transparent_background = require('core.settings').transparent_background
local clear = {}

require('catppuccin').setup({
  transparent_background = transparent_background,
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      underlines = {
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
      },
    },
    aerial = false,
    cmp = true,
    dap = { enabled = true, enable_ui = true },
    fidget = true,
    gitsigns = true,
    hop = true,
    illuminate = true,
    indent_blankline = { enabled = true, colored_indent_levels = false },
    lsp_trouble = true,
    markdown = true,
    mason = true,
    notify = true,
    nvimtree = true,
    semantic_tokens = true,
    symbols_outline = false,
    telescope = true,
    treesitter_context = true,
    ts_rainbow = true,
    which_key = true,
  },
  highlight_overrides = {
    ---@param cp palette
    all = function(cp)
      return {
        -- For base configs
        NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
        FloatBorder = {
          fg = transparent_background and cp.blue or cp.mantle,
          bg = transparent_background and cp.none or cp.mantle,
        },
        CursorLineNr = { fg = cp.green },

        -- For native lsp configs
        DiagnosticVirtualTextError = { bg = cp.none },
        DiagnosticVirtualTextWarn = { bg = cp.none },
        DiagnosticVirtualTextInfo = { bg = cp.none },
        DiagnosticVirtualTextHint = { bg = cp.none },
        LspInfoBorder = { link = 'FloatBorder' },

        -- For mason.nvim
        MasonNormal = { link = 'NormalFloat' },

        -- For indent-blankline
        IndentBlanklineChar = { fg = cp.surface0 },
        IndentBlanklineContextChar = { fg = cp.surface2, style = { 'bold' } },

        -- For nvim-cmp and wilder.nvim
        Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
        PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
        PmenuSel = { bg = cp.green, fg = cp.base },
        CmpItemAbbr = { fg = cp.overlay2 },
        CmpItemAbbrMatch = { fg = cp.blue, style = { 'bold' } },
        CmpDoc = { link = 'NormalFloat' },
        CmpDocBorder = {
          fg = transparent_background and cp.surface1 or cp.mantle,
          bg = transparent_background and cp.none or cp.mantle,
        },

        -- For fidget
        FidgetTask = { bg = cp.none, fg = cp.surface2 },
        FidgetTitle = { fg = cp.blue, style = { 'bold' } },

        -- For nvim-tree
        NvimTreeRootFolder = { fg = cp.pink },
        NvimTreeIndentMarker = { fg = cp.surface0 },

        -- For trouble.nvim
        TroubleNormal = { bg = transparent_background and cp.none or cp.base },

        -- For telescope.nvim
        TelescopeBorder = {
          fg = transparent_background and cp.blue or cp.mantle,
          bg = transparent_background and cp.none or cp.mantle,
        },
        TelescopePromptBorder = {
          fg = transparent_background and cp.blue or cp.surface0,
          bg = transparent_background and cp.none or cp.surface0,
        },
        TelescopePromptNormal = {
          fg = cp.text,
          bg = transparent_background and cp.none or cp.surface0,
        },
        TelescopePromptPrefix = {
          fg = cp.flamingo,
          bg = transparent_background and cp.none or cp.surface0,
        },
        TelescopeNormal = {
          bg = transparent_background and cp.none or cp.mantle,
        },
        TelescopePreviewTitle = {
          fg = transparent_background and cp.green or cp.base,
          bg = transparent_background and cp.none or cp.green,
        },
        TelescopePromptTitle = {
          fg = transparent_background and cp.red or cp.base,
          bg = transparent_background and cp.none or cp.red,
        },
        TelescopeResultsTitle = {
          fg = cp.mantle,
          bg = transparent_background and cp.none or cp.mantle,
        },
        TelescopeSelection = {
          fg = transparent_background and cp.subtext0 or cp.text,
          bg = transparent_background and cp.none or cp.surface0,
        },
        TelescopeResultsDiffAdd = { fg = cp.green },
        TelescopeResultsDiffChange = { fg = cp.yellow },
        TelescopeResultsDiffDelete = { fg = cp.red },

        -- For nvim-cokeline
        TabLineFill = { link = 'StatusLine' },

        -- For status line
        StatusLineHeader = { fg = cp.lavender, bg = cp.crust },
        StatusLineHeaderModified = { fg = cp.rosewater, bg = cp.crust },
        StatusLineStrong = { style = { 'bold'  } },
        StatusLineWeak = { fg = cp.subtext0 },
        StatusLineGitAdded = { fg = cp.green },
        StatusLineGitChanged = { fg = cp.blue },
        StatusLineGitRemoved = { fg = cp.red },
        StatusLineFaded = { fg = cp.subtext0 },
      }
    end,
  },
})
