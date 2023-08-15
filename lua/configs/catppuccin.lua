local transparent = require('core.settings').transparent

require('catppuccin').setup {
  transparent_background = transparent,
  term_colors = true,
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
    cmp = true,
    dropbar = { enabled = true, color_mode = false },
    gitsigns = true,
    indent_blankline = { enabled = true, colored_indent_levels = false },
    markdown = true,
    notify = true,
    nvimtree = true,
    semantic_tokens = true,
    telescope = { enabled = true, style = 'nvchad' },
  },
  highlight_overrides = {
    all = function(cp)
      return {
        -- For base configs
        None = { bg = cp.none },
        FloatBorder = {
          fg = transparent and cp.blue or cp.mantle,
          bg = transparent and cp.none or cp.mantle,
        },
        FloatTitle = {
          fg = transparent and cp.red or cp.base,
          bg = transparent and cp.none or cp.red,
        },

        -- For indent-blankline
        IndentBlanklineContextChar = { fg = cp.surface1 },

        -- For telescope.nvim
        TelescopePromptNormal = { bg = cp.crust },
        TelescopePromptBorder = { fg = cp.crust, bg = cp.crust },
        TelescopePromptPrefix = { bg = cp.crust },

        -- For glance.nvim
        GlanceWinBarFilename = { fg = cp.subtext1, style = { 'bold' } },
        GlanceWinBarFilepath = { fg = cp.subtext0, style = { 'italic' } },
        GlanceWinBarTitle = { fg = cp.mauve, style = { 'bold' } },
        GlanceListCount = { fg = cp.lavender },
        GlanceListFilepath = { link = 'Comment' },
        GlanceListFilename = { fg = cp.blue },
        GlanceListMatch = { fg = cp.lavender, style = { 'bold' } },
        GlanceFoldIcon = { fg = cp.green },

        -- For treesitter
        ['@keyword.return'] = { fg = cp.pink, style = {} },
        ['@error.c'] = { fg = cp.none, style = {} },
        ['@error.cpp'] = { fg = cp.none, style = {} },

        -- For status line
        StatusLineHeader = { fg = cp.lavender, bg = cp.surface0 },
        StatusLineHeaderModified = { fg = cp.peach, bg = cp.surface0 },
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
