local action = require 'ts-node-action'
action.setup {}
local map = require('utils').keymap.set
map('n', '<leader><leader>', function() pcall(action.node_action) end)
