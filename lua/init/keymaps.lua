local map = vim.keymap.set

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
---@param default function
---@param count number?
---@return function
local function tabswitch(default, count)
  return function()
    count = count or vim.v.count
    local tabcount = vim.fn.tabpagenr '$'
    if tabcount >= count then
      default(count ~= 0 and count or nil)
      return
    end
    for _ = 1, count - tabcount do
      vim.cmd.tabnew()
    end
    vim.cmd.tabnext '$'
  end
end

map('n', '<M-j>', tabswitch(vim.cmd.tabnext))
map('n', '<M-k>', tabswitch(vim.cmd.tabprev))
map('n', '<M-q>', '<Cmd>tabclose<CR>')

map('n', '<M-1>', tabswitch(vim.cmd.tabnext, 1))
map('n', '<M-2>', tabswitch(vim.cmd.tabnext, 2))
map('n', '<M-3>', tabswitch(vim.cmd.tabnext, 3))
map('n', '<M-4>', tabswitch(vim.cmd.tabnext, 4))
map('n', '<M-5>', tabswitch(vim.cmd.tabnext, 5))
map('n', '<M-6>', tabswitch(vim.cmd.tabnext, 6))
map('n', '<M-7>', tabswitch(vim.cmd.tabnext, 7))
map('n', '<M-8>', tabswitch(vim.cmd.tabnext, 8))
map('n', '<M-9>', tabswitch(vim.cmd.tabnext, 9))

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
map('n', '<Esc>', '<Cmd>fclose<CR>')
map('n', 'q', '<Cmd>fclose<CR>')

-- Select all file
map(
  'x',
  'af',
  ':<C-u>silent! keepjumps normal! ggVG<CR>',
  { silent = true, noremap = false }
)
