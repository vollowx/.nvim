vim.loader.enable()

vim.g.ui = #vim.api.nvim_list_uis() > 0
vim.g.gui = vim.g.ui and vim.env.DISPLAY ~= nil

require 'core.preferences'
require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
require 'core.packages'
