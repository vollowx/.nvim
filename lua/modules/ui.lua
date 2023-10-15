return {
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
    event = { 'BufReadPost', 'BufNewFile' },
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
