vim.g.vimtex_format_enabled = 1
vim.g.vimtex_imaps_enabled = 0
vim.g.vimtex_mappings_prefix = '<LocalLeader>t'
vim.g.vimtex_quickfix_ignore_filters = {
  [[Font shape `.*' undefined]],
  [[Package fontspec Warning]],
}

vim.api.nvim_create_augroup('VimTexInitMarkdown', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = 'VimTexInitMarkdown',
  callback = function(tbl)
    vim.api.nvim_eval('vimtex#init()')
    vim.api.nvim_eval('vimtex#text_obj#init_buffer()')
    vim.bo[tbl.buf].formatexpr = ''
  end,
})
