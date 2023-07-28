local transparent_background = require('core.settings').transparent_background

require('catppuccin').setup {
  transparent_background = transparent_background,
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
    cmp = true,
    dropbar = true,
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
    ---@param cp palette
    all = function(cp)
      local status_line_bg = transparent_background and cp.none or cp.mantle
      return {
        -- For base configs
        NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
        FloatBorder = {
          fg = transparent_background and cp.surface1 or cp.mantle,
          bg = transparent_background and cp.none or cp.mantle,
        },
        -- For indent-blankline
        IndentBlanklineChar = { fg = cp.surface0 },
        IndentBlanklineContextChar = { fg = cp.surface2 },

        -- For status line
        StatusLineHeader = { fg = cp.lavender, bg = cp.crust },
        StatusLineHeaderModified = { fg = cp.rosewater, bg = cp.crust },
        StatusLineStrong = { fg = cp.text, bg = status_line_bg, style = { 'bold' } },
        StatusLineWeak = { fg = cp.subtext0, bg = status_line_bg },
        StatusLineFaded = { fg = cp.subtext0, bg = status_line_bg },
        StatusLineGitAdded = { fg = cp.green, bg = status_line_bg },
        StatusLineGitChanged = { fg = cp.blue, bg = status_line_bg },
        StatusLineGitRemoved = { fg = cp.red, bg = status_line_bg },
        StatusLineDiagnosticError = { fg = cp.red, bg = status_line_bg },
        StatusLineDiagnosticWarn = { fg = cp.yellow, bg = status_line_bg },
        StatusLineDiagnosticInfo = { fg = cp.blue, bg = status_line_bg },
        StatusLineDiagnosticHint = { fg = cp.rosewater, bg = status_line_bg },
        StatusLineDiagnosticOK = { fg = cp.green, bg = status_line_bg },
      }
    end,
  },
}
