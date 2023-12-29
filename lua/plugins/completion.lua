return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',

      'hrsh7th/cmp-cmdline',
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function() require 'plugins._.cmp' end,
  },

  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      {
        'rafamadriz/friendly-snippets',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
      },
    },
    config = function() require 'plugins._.luasnip' end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function () require 'plugins._.copilot' end,
  },
}
