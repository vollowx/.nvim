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
    },
  },
}
