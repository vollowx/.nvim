-- Override the default fugitive commands to save the previous buffer
-- before opening the log window.
vim.cmd([[
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete Gclog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete GcLog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete Gllog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete GlLog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
]])

local map = require('utils').keymap.set

map('n', '<Leader>gd', '<Cmd>Gdiff<CR>')
map('n', '<Leader>gD', '<Cmd>Git diff<CR>')
map('n', '<Leader>gB', '<Cmd>Git blame<CR>')
map('n', '<Leader>gl', '<Cmd>0Gllog<CR>')
map('n', '<Leader>gq', function()
  if vim.g.fugitive_prevbuf and (vim.bo.ft == 'git' or vim.bo.ft == 'qf') then
    vim.cmd.cclose()
    vim.cmd.lclose()
    vim.cmd.buffer(vim.g.fugitive_prevbuf)
  end
end)

local groupid = vim.api.nvim_create_augroup('FugitiveSettings', {})
vim.api.nvim_create_autocmd('User', {
  pattern = 'FugitiveIndex',
  group = groupid,
  command = 'nmap <buffer> <Tab> = | xmap <buffer> <Tab> =',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'FugitiveObject',
  group = groupid,
  callback = function()
    -- stylua: ignore start
    local goto_next = [[<Cmd>silent! exe "if get(getloclist(0, {'winid':''}), 'winid', 0) | exe v:count.'lne' | else | exe v:count.'cn' | endif"<CR>]]
    local goto_prev = [[<Cmd>silent! exe "if get(getloclist(0, {'winid':''}), 'winid', 0) | exe v:count.'lpr' | else | exe v:count.'cp' | endif"<CR>]]
    -- stylua: ignore end
    map('n', '<C-n>', goto_next, { buffer = true })
    map('n', '<C-p>', goto_prev, { buffer = true })
    map('n', '<C-j>', goto_next, { buffer = true })
    map('n', '<C-k>', goto_prev, { buffer = true })
    map('n', '<C-^>', function()
      if vim.g.fugitive_prevbuf then
        vim.cmd.cclose()
        vim.cmd.lclose()
        vim.cmd.buffer(vim.g.fugitive_prevbuf)
      end
    end, { buffer = true })
  end,
})
