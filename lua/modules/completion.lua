return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = 'L3MON4D3/LuaSnip',
    config = function() require 'configs.cmp' end,
  },

  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    dependencies = 'hrsh7th/nvim-cmp',
  },

  {
    'hrsh7th/cmp-nvim-lsp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'neovim/nvim-lspconfig',
    },
  },

  {
    'hrsh7th/cmp-nvim-lsp-signature-help',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'neovim/nvim-lspconfig',
    },
  },

  {
    'hrsh7th/cmp-path',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = 'hrsh7th/nvim-cmp',
  },

  {
    'hrsh7th/cmp-buffer',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = 'hrsh7th/nvim-cmp',
  },

  {
    'saadparwaiz1/cmp_luasnip',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
    },
  },

  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function() require 'configs.luasnip' end,
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function() require 'configs.copilot' end,
  },
}
