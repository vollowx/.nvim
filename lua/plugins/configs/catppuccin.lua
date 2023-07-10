local transparent_background = require('core.settings').transparent_background

require('catppuccin').setup {
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
    hop = false,
    illuminate = true,
    indent_blankline = { enabled = true, colored_indent_levels = false },
    lsp_trouble = true,
    markdown = true,
    mason = true,
    notify = true,
    nvimtree = true,
    semantic_tokens = true,
    symbols_outline = false,
    telescope = { enabled = true, style = 'nvchad' },
    treesitter_context = false,
    ts_rainbow = true,
    which_key = false,
  },
  highlight_overrides = {
    ---@param cp palette
    all = function(cp)
      return {
        -- For indent-blankline
        IndentBlanklineChar = { fg = cp.surface0 },
        IndentBlanklineContextChar = { fg = cp.surface2, style = { 'bold' } },

        -- For nvim-cmp
        Pmenu = {
          fg = cp.overlay2,
          bg = transparent_background and cp.none or cp.base,
        },
        PmenuBorder = {
          fg = cp.surface1,
          bg = transparent_background and cp.none or cp.base,
        },
        PmenuSel = { bg = cp.green, fg = cp.base },
        CmpItemAbbr = { fg = cp.overlay2 },
        CmpItemAbbrMatch = { fg = cp.blue, style = { 'bold' } },
        CmpDoc = { link = 'NormalFloat' },
        CmpDocBorder = {
          fg = transparent_background and cp.surface1 or cp.mantle,
          bg = transparent_background and cp.none or cp.mantle,
        },

        -- For nvim-tree
        NvimTreeIndentMarker = { fg = cp.surface0 },

        -- For nvim-cokeline
        TabLineFill = { link = 'StatusLine' },

        -- For status line
        StatusLineHeader = { fg = cp.lavender, bg = cp.crust },
        StatusLineHeaderModified = { fg = cp.rosewater, bg = cp.crust },
        StatusLineStrong = { fg = cp.text, bg = cp.mantle, style = { 'bold' } },
        StatusLineWeak = { fg = cp.subtext0, bg = cp.mantle },
        StatusLineFaded = { fg = cp.subtext0, bg = cp.mantle },
        StatusLineGitAdded = { fg = cp.green, bg = cp.mantle },
        StatusLineGitChanged = { fg = cp.blue, bg = cp.mantle },
        StatusLineGitRemoved = { fg = cp.red, bg = cp.mantle },
        StatusLineDiagnosticError = { fg = cp.red, bg = cp.mantle },
        StatusLineDiagnosticWarn = { fg = cp.yellow, bg = cp.mantle },
        StatusLineDiagnosticInfo = { fg = cp.blue, bg = cp.mantle },
        StatusLineDiagnosticHint = { fg = cp.rosewater, bg = cp.mantle },
        StatusLineDiagnosticOK = { fg = cp.green, bg = cp.mantle },
      }
    end,
  },
}
