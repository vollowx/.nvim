return {
  {
    'Jint-lzxy/nvim',
    branch = 'refactor/syntax-highlighting',
    name = 'catppuccin',
    config = function() require 'configs.catppuccin' end,
    lazy = false,
  },

  -- {
  --   'folke/tokyonight.nvim',
  --   event = 'VeryLazy',
  -- },
  --
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   event = 'VeryLazy',
  -- },
  --
  -- {
  --   'sainnhe/everforest',
  --   event = 'VeryLazy',
  -- },
}
