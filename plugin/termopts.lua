vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('TermOptsSetup', {}),
  callback = function(info) require('plugin.termopts').setup(info.buf) end,
})
