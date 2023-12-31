return {
  {
    'neovim/nvim-lspconfig',
    event = 'FileType',
    cmd = { 'LspInfo', 'LspStart' },
    config = function()
      vim.schedule(function() require 'configs.lspconfig' end)
    end,
  },

  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function() require 'configs.symbol-usage' end,
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function() require 'configs.glance' end,
  },
}
