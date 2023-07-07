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
    config = function()
      require('plugins.configs.cokeline')
    end,
    events = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('plugins.configs.nvim-tree')
    end,
    lazy = true,
    keys = { '<C-n>' },
    cmd = {
      'NvimTreeOpen', 'NvimTreeClose', 'NvimTreeToggle', 'NvimTreeFocus',
      'NvimTreeRefresh', 'NvimTreeFindFile', 'NvimTreeFindFileToggle',
      'NvimTreeClipboard', 'NvimTreeResize', 'NvimTreeCollapse',
      'NvimTreeCollapseKeepBuffers', 'NvimTreeGenerateOnAttach'
    },
  },
  {
    'Bekaboo/deadcolumn.nvim',
    events = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  {
    'j-hui/fidget.nvim',
    config = function()
      require('plugins.configs.fidget')
    end,
    event = 'LspAttach',
  },
}
