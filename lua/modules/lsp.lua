return {
  {
    'neovim/nvim-lspconfig',
    event = 'User File',
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
    'jose-elias-alvarez/null-ls.nvim',
    event = 'User File',
    cmd = {
      'NullLsLog',
      'NullLsInfo',
    },
    dependencies = { 'plenary.nvim' },
    config = function() require 'configs.null-ls' end,
    keys = {
      {
        '<Leader>ni',
        '<Cmd>NullLsInfo<CR>',
        desc = 'null-ls: Server information',
      },
    },
  },

  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    dependencies = 'nvim-lspconfig',
    config = function() require 'configs.clangd_extensions' end,
  },

  {
    'folke/neodev.nvim',
    config = function() require 'configs.neodev' end,
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function() require 'configs.glance' end,
  },
}
