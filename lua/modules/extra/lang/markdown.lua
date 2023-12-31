return {
  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    ft = 'markdown',
    config = function() require 'configs.table-mode' end,
  },

  {
    'iamcco/markdown-preview.nvim',
    enabled = vim.g.gui,
    ft = 'markdown',
    build = function() vim.fn['mkdp#util#install']() end,
    config = function() require 'configs.markdown-preview' end,
    keys = {
      {
        '<F10>',
        ft = 'markdown',
        '<Cmd>MarkdownPreviewToggle<CR>',
        desc = 'Markdown Preview',
      },
    },
  },

  {
    'lukas-reineke/headlines.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = { 'markdown', 'norg', 'rmd', 'org' },
    config = function()
      vim.schedule(function() require 'configs.headlines' end)
    end,
  },
}
