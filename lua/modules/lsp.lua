return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = function() require 'configs.nvim-lspconfig' end,
    cmd = { 'LspInfo', 'LspStart' },
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
    dependencies = 'nvim-lspconfig',
    ft = { 'c', 'cpp' },
    config = function() require 'configs.clangd_extensions' end,
  },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'nvim-lspconfig',
    event = 'VeryLazy',
    config = function() require 'configs.typescript-tools' end,
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function() require 'configs.glance' end,
  },
}
