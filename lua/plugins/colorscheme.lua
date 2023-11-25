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
        gitsigns = true,
        headlines = true,
        indent_blankline = { enabled = true, scope_color = 'surface2' },
        markdown = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = { enabled = true, style = 'nvchad' },
      },
      highlight_overrides = {
        all = function(cp) return { WinSeparator = { fg = cp.surface0 } } end,
      },
    },
  },
}
