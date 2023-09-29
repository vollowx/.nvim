return {
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.dressing' end,
  },
  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufWritePost' },
    config = function() require 'configs.dropbar' end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function() require 'configs.indent-blankline' end,
  },
  {
    'yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    config = function() require 'configs.pqf' end,
  },
  {
    'utilyre/sentiment.nvim',
    event = 'VeryLazy',
    init = function() vim.g.loaded_matchparen = 1 end,
    config = function() require 'configs.sentiment' end,
  },
}
