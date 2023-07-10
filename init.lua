require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
require 'plugins'

vim.cmd('colorscheme ' .. require('core.settings').colorscheme)
