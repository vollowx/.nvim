vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = 'no'
vim.opt_local.scrolloff = 999

vim.keymap.set({ 'n', 'x' }, 'q', 'ZQ', { buffer = true, nowait = true })
vim.keymap.set({ 'n', 'x' }, 'd', '<C-d>', { buffer = true, nowait = true })
vim.keymap.set({ 'n', 'x' }, 'u', '<C-u>', { buffer = true, nowait = true })

vim.cmd 'normal! M'
