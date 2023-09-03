local transparent = require('core.settings').transparent

require('catppuccin').setup {
  transparent_background = transparent,
  integrations = {
    alpha = false,
    dashboard = false,
    flash = false,
    neogit = false,
    nvimtree = false,

    treesitter = true,
    native_lsp = { enabled = true },
    cmp = true,
    dropbar = { enabled = true, color_mode = true },
    gitsigns = true,
    illuminate = true,
    indent_blankline = { enabled = true },
    markdown = true,
    notify = true,
    neotree = true,
    semantic_tokens = true,
    telescope = { enabled = true, style = 'nvchad' },
  },
  highlight_overrides = {
    all = function(cp)
      return {
        -- For base configs
        None = { bg = cp.none },
        WinSeparator = { fg = cp.surface0 },
        FloatBorder = {
          fg = transparent and cp.blue or cp.mantle,
          bg = transparent and cp.none or cp.mantle,
        },
        FloatTitle = {
          fg = transparent and cp.blue or cp.mantle,
          bg = transparent and cp.none or cp.mantle,
        },

        -- For native lsp configs
        DiagnosticVirtualTextError = { bg = cp.none },
        DiagnosticVirtualTextWarn = { bg = cp.none },
        DiagnosticVirtualTextInfo = { bg = cp.none },
        DiagnosticVirtualTextHint = { bg = cp.none },

        -- For telescope.nvim
        TelescopePromptNormal = { bg = transparent and cp.none or cp.crust },
        TelescopePromptBorder = {
          fg = transparent and cp.blue or cp.crust,
          bg = transparent and cp.none or cp.crust,
        },
        TelescopePromptPrefix = { bg = transparent and cp.none or cp.crust },

        -- For glance.nvim
        GlanceWinBarFilename = {
          fg = cp.subtext1,
          bg = transparent and cp.none or cp.mantle,
          style = { 'bold' },
        },
        GlanceWinBarFilepath = {
          fg = cp.subtext0,
          bg = transparent and cp.none or cp.mantle,
          style = { 'italic' },
        },
        GlancePreviewNormal = { bg = transparent and cp.none or cp.mantle },
        GlanceWinBarTitle = {
          fg = cp.lavender,
          bg = transparent and cp.none or cp.crust,
          style = { 'bold' },
        },
        GlanceListNormal = { bg = transparent and cp.none or cp.crust },
        GlanceListFilepath = { link = 'Comment' },
        GlanceListFilename = { fg = cp.blue },
        GlanceListCount = { fg = cp.peach },
        GlanceListMatch = { fg = cp.teal, style = { 'bold' } },
        GlanceFoldIcon = { fg = cp.overlay0 },
        GlanceIndent = { fg = cp.overlay0 },

        -- For status line
        StatusLineDiagnosticError = { fg = cp.red, bg = cp.mantle },
        StatusLineDiagnosticWarn = { fg = cp.yellow, bg = cp.mantle },
        StatusLineDiagnosticInfo = { fg = cp.blue, bg = cp.mantle },
        StatusLineDiagnosticHint = { fg = cp.teal, bg = cp.mantle },
        StatusLineFaded = { fg = cp.subtext0, bg = cp.mantle },
        StatusLineGitAdded = { fg = cp.green, bg = cp.mantle },
        StatusLineGitChanged = { fg = cp.blue, bg = cp.mantle },
        StatusLineGitRemoved = { fg = cp.red, bg = cp.mantle },
        StatusLineHeader = {
          fg = cp.lavender,
          bg = transparent and cp.none or cp.surface0,
        },
        StatusLineHeaderModified = {
          fg = cp.pink,
          bg = transparent and cp.none or cp.surface0,
        },
        StatusLineStrong = { fg = cp.text, bg = cp.mantle, style = { 'bold' } },
      }
    end,
  },
}
