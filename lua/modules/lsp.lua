return {
  {
    'neovim/nvim-lspconfig',
    config = function() require 'configs.nvim-lspconfig' end,
    event = 'VeryLazy',
    cmd = { 'LspInfo', 'LspStart' },
    keys = {
      { '<Leader>li', '<Cmd>LspInfo<CR>', desc = 'lsp: Server information' },
      { '<Leader>lr', '<Cmd>LspRestart<CR>', desc = 'lsp: Restart server' },
      { '<Leader>ls', '<Cmd>LspStart<CR>', desc = 'lsp: Start server' },
      { '<Leader>lp', '<Cmd>LspStop<CR>', desc = 'lsp: Stop server' },
    },
  },

  {
    'p00f/clangd_extensions.nvim',
    dependencies = 'nvim-lspconfig',
    config = function() require 'configs.clangd_extensions' end,
    ft = { 'c', 'cpp' },
  },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = 'nvim-lspconfig',
    config = function() require 'configs.typescript-tools' end,
    event = 'VeryLazy',
  },

  {
    'dnlhc/glance.nvim',
    config = function() require 'configs.glance' end,
    event = 'LspAttach',
  },
}
