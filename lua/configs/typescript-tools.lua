local on_attach = require('configs.lsp-server-configs.shared.default').on_attach

require('typescript-tools').setup {
  on_attach = on_attach,
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = 'all',
      includeCompletionsForModuleExports = true,
      quotePreference = 'auto',
    },
  },
}
