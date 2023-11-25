return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'nvim-lspconfig',
    event = 'LazyFile',
    opts = function()
      local on_attach =
        require('configs.lsp-server-configs.shared.default').on_attach

      return {
        on_attach = on_attach,
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeCompletionsForModuleExports = true,
            quotePreference = 'auto',
          },
        },
      }
    end,
  },
}
