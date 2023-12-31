return {
  {
    'dhruvasagar/vim-table-mode',
    ft = 'markdown',
  },

  {
    'iamcco/markdown-preview.nvim',
    enabled = vim.g.gui,
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function() vim.fn['mkdp#util#install']() end,
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
      vim.schedule(function() require 'packages._.headlines' end)
    end,
  },
}
