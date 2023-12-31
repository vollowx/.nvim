require('typescript-tools').setup {
  vim.tbl_deep_extend('force', require 'configs.lsp.default', {
    settings = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeCompletionsForModuleExports = true,
        quotePreference = 'auto',
      },
    },
  }),
}
