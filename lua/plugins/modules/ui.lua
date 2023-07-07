return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('plugins.configs.catppuccin')
    end,
  },
  {
    'willothy/nvim-cokeline',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('plugins.configs.cokeline')
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    lazy = true,
    cmd = {
      'NvimTreeOpen', 'NvimTreeClose', 'NvimTreeToggle', 'NvimTreeFocus',
      'NvimTreeRefresh', 'NvimTreeFindFile', 'NvimTreeFindFileToggle',
      'NvimTreeClipboard', 'NvimTreeResize', 'NvimTreeCollapse',
      'NvimTreeCollapseKeepBuffers', 'NvimTreeGenerateOnAttach'
    },
    keys = { '<C-n>' },
    config = function()
      require('plugins.configs.nvim-tree')
    end,
  },
  {
    'Bekaboo/deadcolumn.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'j-hui/fidget.nvim',
    lazy = true,
    event = 'LspAttach',
    config = function()
      require('plugins.configs.fidget')
    end,
  },
}
