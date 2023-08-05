local transparent = require('core.settings').transparent

require('catppuccin').setup {
  transparent_background = transparent,
  term_colors = true,
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
    cmp = true,
    dropbar = { enabled = true, color_mode = false },
    fidget = true,
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
        FloatBorder = {
          fg = transparent and cp.blue or cp.mantle,
          bg = transparent and cp.none or cp.mantle,
        },
        FloatTitle = {
          fg = transparent and cp.red or cp.base,
          bg = transparent and cp.none or cp.red,
        },

        -- For indent-blankline
        IndentBlanklineChar = { fg = cp.surface0 },
        IndentBlanklineContextChar = { fg = cp.surface2 },

        -- For fidget
        FidgetTask = { bg = cp.none, fg = cp.surface2 },
        FidgetTitle = { fg = cp.blue, style = { 'bold' } },

        -- For nvim-tree
        NvimTreeRootFolder = { fg = cp.pink },

        -- For telescope.nvim
        TelescopeMatching = { fg = cp.lavender },
        TelescopeResultsDiffAdd = { fg = cp.green },
        TelescopeResultsDiffChange = { fg = cp.yellow },
        TelescopeResultsDiffDelete = { fg = cp.red },

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
        StatusLineNone = { bg = cp.base },
        StatusLineHeader = { fg = cp.lavender, bg = cp.mantle },
        StatusLineHeaderModified = { fg = cp.peach, bg = cp.mantle },
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
