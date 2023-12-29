require('catppuccin').setup {
  integrations = {
    alpha = false,
    dap = false,
    dap_ui = false,
    dashboard = false,
    flash = false,
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
    illuminate = true,
    indent_blankline = { enabled = true, scope_color = 'surface2' },
    markdown = true,
    rainbow_delimiters = true,
    semantic_tokens = true,
    telescope = { enabled = true, style = 'nvchad' },
  },
  highlight_overrides = {
    all = function(cp)
      return {
        WinSeparator = { fg = cp.surface0 },
        NormalFloat = { bg = cp.mantle },
        FloatBorder = { bg = cp.mantle, fg = cp.mantle },
        FloatTitle = { bg = cp.mantle, fg = cp.mantle },
        LspInfoBorder = { link = 'FloatBorder' },

        GlanceWinBarFilename = { fg = cp.subtext1, style = { 'bold' } },
        GlanceWinBarFilepath = { fg = cp.subtext0, style = { 'italic' } },
        GlanceWinBarTitle = { fg = cp.teal, style = { 'bold' } },
        GlanceListCount = { fg = cp.lavender },
        GlanceListFilepath = { link = 'Comment' },
        GlanceListFilename = { fg = cp.blue },
        GlanceListMatch = { fg = cp.lavender, style = { 'bold' } },
        GlanceFoldIcon = { fg = cp.green },

        TelescopePreviewBorder = { bg = cp.crust, fg = cp.crust },
        TelescopePreviewNormal = { bg = cp.crust },
        TelescopePreviewTitle = { fg = cp.crust, bg = cp.crust },
        TelescopePromptBorder = {
          bg = cp.surface0,
          fg = cp.surface0,
        },
        TelescopePromptCounter = { fg = cp.mauve, style = { 'bold' } },
        TelescopePromptNormal = { bg = cp.surface0 },
        TelescopePromptPrefix = { bg = cp.surface0 },
        TelescopePromptTitle = {
          fg = cp.surface0,
          bg = cp.surface0,
        },
        TelescopeResultsBorder = { bg = cp.mantle, fg = cp.mantle },
        TelescopeResultsNormal = { bg = cp.mantle },
        TelescopeResultsTitle = { fg = cp.mantle, bg = cp.mantle },
      }
    end,
  },
}
