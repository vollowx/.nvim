return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    config = function() require 'packages._.typescript-tools' end,
  },
}
