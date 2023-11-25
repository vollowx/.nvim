local map = vim.keymap.set
local utils = require 'utils'
local opts = { noremap = true, silent = true }

map({ 'n', 'x' }, '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Window/Buffer/Tab navigation and operations
map('n', 's<Esc>', '<Ignore>')

map('n', 'sq', '<Cmd>quit<CR>', opts)
map('n', 'ss', '<Cmd>split<CR>', opts)
map('n', 'sv', '<Cmd>vsplit<CR>', opts)
map('n', 'sh', '<C-w>h')
map('n', 'sk', '<C-w>k')
map('n', 'sj', '<C-w>j')
map('n', 'sl', '<C-w>l')

map('n', 'sd', '<Cmd>bdelete<CR>', opts)
map('n', ']b', '<Cmd>bnext<CR>', opts)
map('n', '[b', '<Cmd>bprevious<CR>', opts)

map('n', 'sn', '<Cmd>tabnew<CR>', opts)
map('n', 'sc', '<Cmd>tabclose<CR>', opts)
map('n', 'sn', '<Cmd>tabnext<CR>', opts)
map('n', 'sp', '<Cmd>tabprevious<CR>', opts)

-- Up/down motions
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })

-- Float terminals
map({ 'n', 't' }, '<M-Space>', function() utils.fterm(nil, {}) end)
map({ 'n', 't' }, '<M-i>', function() utils.fterm({ 'lazygit' }, {}) end)

-- Correct misspelled word / mark as correct
map('i', '<C-S-L>', '<Esc>[szg`]a')
map('i', '<C-l>', '<C-G>u<Esc>[s1z=`]a<C-G>u')

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
map(
  'n',
  '<Esc>',
  function()
    return vim.v.hlsearch == 1 and '<Cmd>nohlsearch<Bar>diffupdate<Bar>echo<CR>'
      or '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-l><CR>'
  end,
  { expr = true, desc = 'search: Clear highlights' }
)

-- Increment/decrement
map('n', '+', '<C-a>')
map('n', '-', '<C-x>')

-- Close all floating windows
map('n', 'q', '<Cmd>fclose<CR>')

-- Select all file
map(
  'x',
  'af',
  ':<C-u>silent! keepjumps normal! ggVG<CR>',
  { silent = true, noremap = false }
)
