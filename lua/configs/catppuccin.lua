local transparent = require('init.settings').transparent

require('catppuccin').setup {
  transparent_background = transparent,
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
        FloatBorder = {
          fg = transparent and cp.blue or cp.mantle,
          bg = transparent and cp.none or cp.mantle,
        },
        FloatTitle = {
          fg = transparent and cp.blue or cp.base,
          bg = transparent and cp.none or cp.red,
        },

        -- For telescope.nvim
        TelescopePromptNormal = { bg = transparent and cp.none or cp.crust },
        TelescopePromptBorder = {
          fg = transparent and cp.blue or cp.crust,
          bg = transparent and cp.none or cp.crust,
        },
        TelescopePromptPrefix = { bg = transparent and cp.none or cp.crust },

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
