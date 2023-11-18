require('bufferline').setup {
  options = {
    always_show_bufferline = false,
    indicator = { style = 'none' },
    separator_style = { '', '' },
    tab_size = 20,
  },
  highlights = require('catppuccin.groups.integrations.bufferline').get(),
}

vim.api.nvim_create_autocmd('BufAdd', {
  callback = function()
    vim.schedule(function() pcall(nvim_bufferline) end)
  end,
})
