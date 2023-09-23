return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    cmd = { 'LspInfo', 'LspStart' },
    config = function() require 'configs.nvim-lspconfig' end,
    keys = {
      { '<Leader>li', '<Cmd>LspInfo<CR>', desc = 'lsp: Server information' },
      { '<Leader>lr', '<Cmd>LspRestart<CR>', desc = 'lsp: Restart server' },
      { '<Leader>ls', '<Cmd>LspStart<CR>', desc = 'lsp: Start server' },
      { '<Leader>lp', '<Cmd>LspStop<CR>', desc = 'lsp: Stop server' },
    },
  },

  {
    'stevearc/conform.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.conform' end,
  },

  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    dependencies = 'nvim-lspconfig',
    config = function() require 'configs.clangd_extensions' end,
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function() require 'configs.glance' end,
  },
}
