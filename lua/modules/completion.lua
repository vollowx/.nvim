return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = 'LuaSnip',
    config = function() require 'configs.nvim-cmp' end,
  },

  {
    'hrsh7th/cmp-cmdline',
    dependencies = 'nvim-cmp',
    event = 'CmdlineEnter',
  },

  {
    'hrsh7th/cmp-nvim-lsp',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
    event = 'InsertEnter',
  },

  {
    'hrsh7th/cmp-nvim-lsp-signature-help',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
    event = 'InsertEnter',
  },

  {
    'hrsh7th/cmp-path',
    dependencies = 'nvim-cmp',
    event = { 'CmdlineEnter', 'InsertEnter' },
  },

  {
    'hrsh7th/cmp-buffer',
    dependencies = 'nvim-cmp',
    event = { 'CmdlineEnter', 'InsertEnter' },
  },

  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = { 'nvim-cmp', 'LuaSnip' },
    event = 'InsertEnter',
  },

  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
    },
    event = 'InsertEnter',
    config = function() require 'configs.LuaSnip' end,
  },
}
