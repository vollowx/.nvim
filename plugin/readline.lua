vim.api.nvim_create_augroup('ReadlineSetup', { clear = true })
vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'InsertEnter' }, {
  group = 'ReadlineSetup',
  once = true,
  callback = function()
    require('plugin.readline').setup()
    return true
  end,
})
