require('typescript-tools').setup {
  vim.tbl_deep_extend('force', require 'packages._.lsp.default', {
    settings = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeCompletionsForModuleExports = true,
        quotePreference = 'auto',
      },
    },
  }),
}
