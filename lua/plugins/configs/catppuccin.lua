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
    aerial = true,
    cmp = true,
    dap = { enabled = true, enable_ui = true },
    dropbar = true;
    fidget = true,
    gitsigns = true,
    hop = false,
    indent_blankline = { enabled = true, colored_indent_levels = false },
    markdown = true,
    mason = true,
    notify = true,
    nvimtree = true,
    semantic_tokens = true,
    telescope = { enabled = true, style = 'nvchad' },
    treesitter_context = false,
    ts_rainbow = true,
    which_key = false,
  },
  highlight_overrides = {
    ---@param cp palette
    all = function(cp)
      local status_line_bg = transparent_background and cp.none or cp.mantle
      return {
        -- For indent-blankline
        IndentBlanklineChar = { fg = cp.surface0 },
        IndentBlanklineContextChar = { fg = cp.surface2, style = { 'bold' } },

        -- For nvim-tree
        NvimTreeIndentMarker = { fg = cp.surface0 },

        -- For nvim-cokeline
        TabLineFill = { link = 'StatusLine' },

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
