local dap = require 'dap'
local static = require 'utils.static'

local map = require('utils.keymap').set

map('n', '<F1>', dap.up, { noremap = true })
map('n', '<F2>', dap.down, { noremap = true })
map('n', '<F5>', dap.continue, { noremap = true })
map('n', '<F6>', dap.pause, { noremap = true })
map('n', '<F8>', dap.repl.open, { noremap = true })
map('n', '<F9>', dap.toggle_breakpoint, { noremap = true })
map('n', '<F10>', dap.step_over, { noremap = true })
map('n', '<F11>', dap.step_into, { noremap = true })
map('n', '<F17>', dap.terminate, { noremap = true })
map('n', '<F23>', dap.step_out, { noremap = true })
map('n', '<F41>', dap.restart, { noremap = true })
-- Use shift + <F9> to set breakpoint condition
map('n', '<F21>', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { noremap = true })
-- Use control + shift + <F9> to set breakpoint log message
map('n', '<F45>', function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end, { noremap = true })

vim.api.nvim_create_user_command('DapClear', dap.clear_breakpoints, { desc = 'Clear all breakpoints' })

-- stylua: ignore start
vim.fn.sign_define('DapBreakpoint',          { text = vim.trim(static.icons.DotLarge), texthl = 'Tea' })
vim.fn.sign_define('DapBreakpointCondition', { text = vim.trim(static.icons.Diamond), texthl = 'Conditional' })
vim.fn.sign_define('DapBreakpointRejected',  { text = vim.trim(static.icons.DotLarge), texthl = 'Iron' })
vim.fn.sign_define('DapLogPoint',            { text = vim.trim(static.icons.Log), texthl = 'Skyblue' })
vim.fn.sign_define('DapStopped',             { text = vim.trim(static.icons.ArrowRight), texthl = 'yellow' })
-- stylua: ignore end

dap.adapters = require 'plugins.configs.dap-configs.adapters'
dap.configurations = require 'plugins.configs.dap-configs.configurations'
