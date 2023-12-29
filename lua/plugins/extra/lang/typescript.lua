return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    config = function() require 'plugins._.typescript-tools' end,
  },
}
