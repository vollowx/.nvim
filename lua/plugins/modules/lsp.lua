local map = require('utils').keymap.set

map('n', '<Leader>li', '<Cmd>LspInfo<CR>', { desc = 'lsp: Server info' })

return {
  {
    'neovim/nvim-lspconfig',
    event = 'FileType',
    config = function() require 'plugins.configs.nvim-lspconfig' end,
  },

  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    dependencies = 'nvim-lspconfig',
    config = function() require 'plugins.configs.clangd_extensions' end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'FileType',
    cmd = {
      'NullLsLog',
      'NullLsInfo',
      'NullLsFormatOnSaveToggle',
    },
    dependencies = { 'plenary.nvim' },
    config = function() require 'plugins.configs.null-ls' end,
  },

  {
    'folke/neodev.nvim',
    config = function() require 'plugins.configs.neodev' end,
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function() require 'plugins.configs.glance' end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function() require 'plugins.configs.fidget' end,
  },
}
