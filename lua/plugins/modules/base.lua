return {
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },

  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    config = function()
      require('plugins.configs.nvim-web-devicons')
    end,
  },
}
