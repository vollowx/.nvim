vim.opt_local.list = false
vim.opt_local.spell = false
vim.opt_local.conceallevel = vim.bo.ma and 0 or 1

vim.keymap.set({ 'n', 'x' }, 'q', 'ZQ', { buffer = true, nowait = true })
