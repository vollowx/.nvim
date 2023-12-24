return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = function()
      return vim.tbl_deep_extend('force', require 'plugins._lsp.default', {
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeCompletionsForModuleExports = true,
            quotePreference = 'auto',
          },
        },
      })
    end,
  },
}
