return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function() require 'configs.catppuccin' end,
    lazy = false,
    priority = 1000,
  },

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'scope.nvim' },
    event = 'VeryLazy',
    config = function() require 'configs.bufferline' end,
    keys = {
      { 'H', '<Cmd>BufferLineCyclePrev<CR>' },
      { 'L', '<Cmd>BufferLineCycleNext<CR>' },
      { '<M-S-1>', '<Cmd>ScopeMoveBuf 1<CR>' },
      { '<M-S-2>', '<Cmd>ScopeMoveBuf 2<CR>' },
      { '<M-S-3>', '<Cmd>ScopeMoveBuf 3<CR>' },
      { '<M-S-4>', '<Cmd>ScopeMoveBuf 4<CR>' },
      { '<M-S-5>', '<Cmd>ScopeMoveBuf 5<CR>' },
      { '<M-S-6>', '<Cmd>ScopeMoveBuf 6<CR>' },
      { '<M-S-7>', '<Cmd>ScopeMoveBuf 7<CR>' },
      { '<M-S-8>', '<Cmd>ScopeMoveBuf 8<CR>' },
      { '<M-S-9>', '<Cmd>ScopeMoveBuf 9<CR>' },
    },
  },
  {
    'tiagovla/scope.nvim',
    config = function() require 'configs.scope' end,
  },

  {
    'stevearc/dressing.nvim',
    config = function() require 'configs.dressing' end,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'LazyFile',
    config = function() require 'configs.indent-blankline' end,
  },
  {
    'yorickpeterse/nvim-pqf',
    config = function() require 'configs.pqf' end,
    event = 'VeryLazy',
  },
  {
    'utilyre/sentiment.nvim',
    config = function() require 'configs.sentiment' end,
    init = function() vim.g.loaded_matchparen = 1 end,
    event = 'VeryLazy',
  },
}
