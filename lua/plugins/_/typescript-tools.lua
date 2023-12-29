require('typescript-tools').setup {
  vim.tbl_deep_extend('force', require 'plugins._.lsp.default', {
    settings = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeCompletionsForModuleExports = true,
        quotePreference = 'auto',
      },
    },
  }),
}
