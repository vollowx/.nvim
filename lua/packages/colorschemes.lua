return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function() require 'packages._.catppuccin' end,
  },

  { 'sainnhe/everforest' },
}