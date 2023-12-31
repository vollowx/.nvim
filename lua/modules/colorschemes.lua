return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function() require 'configs.catppuccin' end,
  },

  { 'sainnhe/everforest' },
}
