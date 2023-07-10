vim.api.nvim_create_augroup('TableModeSetTableCorner', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'markdown',
  group = 'TableModeSetTableCorner',
  command = 'let b:table_mode_corner = "|"',
})

vim.api.nvim_create_augroup('TableModeFormatOnSave', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.txt', '*.md' },
  group = 'TableModeFormatOnSave',
  callback = function()
    if vim.api.nvim_get_current_line():match '^%s*|' then vim.cmd 'silent! TableModeRealign' end
  end,
})
