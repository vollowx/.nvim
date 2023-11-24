local map = vim.keymap.set
local utils = require 'utils'

map({ 'n', 'x' }, '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Multi-window operations
map({ 'x', 'n' }, '<C-h>', '<C-w><C-h>')
map({ 'x', 'n' }, '<C-j>', '<C-w><C-j>')
map({ 'x', 'n' }, '<C-k>', '<C-w><C-k>')
map({ 'x', 'n' }, '<C-l>', '<C-w><C-l>')

-- Up/down motions
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })

-- Buffer navigation
map('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
map('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')

-- Tabpages
---@param tab_action function
---@param default_count number?
---@return function
local function tabswitch(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = vim.fn.tabpagenr '$'
    if num_tabs >= count then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end
map('n', 'gt', tabswitch(vim.cmd.tabnext))
map('n', 'gT', tabswitch(vim.cmd.tabprev))
map('n', 'gy', tabswitch(vim.cmd.tabprev))

map('n', '<Leader>0', '<Cmd>0tabnew<CR>')
map('n', '<Leader>1', tabswitch(vim.cmd.tabnext, 1))
map('n', '<Leader>2', tabswitch(vim.cmd.tabnext, 2))
map('n', '<Leader>3', tabswitch(vim.cmd.tabnext, 3))
map('n', '<Leader>4', tabswitch(vim.cmd.tabnext, 4))
map('n', '<Leader>5', tabswitch(vim.cmd.tabnext, 5))
map('n', '<Leader>6', tabswitch(vim.cmd.tabnext, 6))
map('n', '<Leader>7', tabswitch(vim.cmd.tabnext, 7))
map('n', '<Leader>8', tabswitch(vim.cmd.tabnext, 8))
map('n', '<Leader>9', tabswitch(vim.cmd.tabnext, 9))

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
  { expr = true }
)

map('n', '<C-s>', '<Cmd>w<CR>')

-- Close all floating windows
map('n', 'q', '<Cmd>fclose<CR>')

-- Select all file
map(
  'x',
  'af',
  ':<C-u>silent! keepjumps normal! ggVG<CR>',
  { silent = true, noremap = false }
)
