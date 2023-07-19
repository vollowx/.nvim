return {
  {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.configs.nvim-cmp' end,
    dependencies = 'LuaSnip',
  },

  {
    'hrsh7th/cmp-calc',
    event = 'InsertEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-nvim-lsp',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
  },

  {
    'hrsh7th/cmp-nvim-lsp-signature-help',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
  },

  {
    'hrsh7th/cmp-path',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-buffer',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = 'nvim-cmp',
  },

  {
    'rcarriga/cmp-dap',
    dependencies = { 'nvim-dap', 'nvim-cmp' },
  },

  {
    'saadparwaiz1/cmp_luasnip',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'LuaSnip' },
  },

  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function() require 'plugins.configs.LuaSnip' end,
  },
}
