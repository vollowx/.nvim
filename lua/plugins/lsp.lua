return {
  {
    'neovim/nvim-lspconfig',
    event = 'FileType',
    cmd = { 'LspInfo', 'LspStart' },
    config = function()
      vim.schedule(function() require 'plugins._.lspconfig' end)
    end,
  },

  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function() require 'plugins._.symbol-usage' end,
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    keys = {
      { 'gd', '<Cmd>Glance definitions<CR>' },
      { 'gD', '<Cmd>Glance type_definitions<CR>' },
      { 'gr', '<Cmd>Glance references<CR>' },
      { 'gi', '<Cmd>Glance implementations<CR>' },
    },
    config = function() require 'plugins._.glance' end,
  },
}
