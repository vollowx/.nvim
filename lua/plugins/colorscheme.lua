return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      integrations = {
        alpha = false,
        dap = false,
        dap_ui = false,
        dashboard = false,
        flash = false,
        illuminate = false,
        neogit = false,
        mini = { enabled = false },
        nvimtree = false,
        ufo = false,

        treesitter = true,
        treesitter_context = true,
        native_lsp = { enabled = true },
        cmp = true,
        gitsigns = true,
        headlines = true,
        indent_blankline = { enabled = true, scope_color = 'surface2' },
        markdown = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = { enabled = true, style = 'nvchad' },
      },
      highlight_overrides = {
        all = function(cp)
          return {
            GlanceWinBarFilename = { fg = cp.subtext1, style = { 'bold' } },
            GlanceWinBarFilepath = { fg = cp.subtext0, style = { 'italic' } },
            GlanceWinBarTitle = { fg = cp.teal, style = { 'bold' } },
            GlanceListCount = { fg = cp.lavender },
            GlanceListFilepath = { link = 'Comment' },
            GlanceListFilename = { fg = cp.blue },
            GlanceListMatch = { fg = cp.lavender, style = { 'bold' } },
            GlanceFoldIcon = { fg = cp.green },
          }
        end,
      },
    },
  },
}
