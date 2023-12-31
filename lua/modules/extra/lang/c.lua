return {
  {
    'p00f/clangd_extensions.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp' },
    config = function() require 'configs.clangd_extensions' end,
  },
}
