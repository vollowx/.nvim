return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    config = function() require 'configs.typescript-tools' end,
  },
}
