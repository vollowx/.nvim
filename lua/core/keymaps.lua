local map = vim.keymap.set
local utils = require 'utils'

map({ 'n', 'x' }, '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Multi-window operations
-- stylua: ignore start
map({ 'x', 'n' }, '<M-W>',      '<C-w>W')
map({ 'x', 'n' }, '<M-H>',      '<C-w>H')
map({ 'x', 'n' }, '<M-J>',      '<C-w>J')
map({ 'x', 'n' }, '<M-K>',      '<C-w>K')
map({ 'x', 'n' }, '<M-L>',      '<C-w>L')
map({ 'x', 'n' }, '<M-=>',      '<C-w>=')
map({ 'x', 'n' }, '<M-_>',      '<C-w>_')
map({ 'x', 'n' }, '<M-|>',      '<C-w>|')
map({ 'x', 'n' }, '<M->>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
map({ 'x', 'n' }, '<M-<>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
map({ 'x', 'n' }, '<M-.>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
map({ 'x', 'n' }, '<M-,>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
map({ 'x', 'n' }, '<M-+>',      'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
map({ 'x', 'n' }, '<M-->',      'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
map({ 'x', 'n' }, '<M-p>',      '<C-w>p')
map({ 'x', 'n' }, '<M-r>',      '<C-w>r')
map({ 'x', 'n' }, '<M-v>',      '<C-w>v')
map({ 'x', 'n' }, '<M-s>',      '<C-w>s')
map({ 'x', 'n' }, '<M-x>',      '<C-w>x')
map({ 'x', 'n' }, '<M-z>',      '<C-w>z')
map({ 'x', 'n' }, '<M-c>',      '<C-w>c')
map({ 'x', 'n' }, '<M-n>',      '<C-w>n')
map({ 'x', 'n' }, '<M-o>',      '<C-w>o')
map({ 'x', 'n' }, '<M-t>',      '<C-w>t')
map({ 'x', 'n' }, '<M-T>',      '<C-w>T')
map({ 'x', 'n' }, '<M-]>',      '<C-w>]')
map({ 'x', 'n' }, '<M-^>',      '<C-w>^')
map({ 'x', 'n' }, '<M-b>',      '<C-w>b')
map({ 'x', 'n' }, '<M-d>',      '<C-w>d')
map({ 'x', 'n' }, '<M-f>',      '<C-w>f')
map({ 'x', 'n' }, '<M-}>',      '<C-w>}')
map({ 'x', 'n' }, '<M-g>]',     '<C-w>g]')
map({ 'x', 'n' }, '<M-g>}',     '<C-w>g}')
map({ 'x', 'n' }, '<M-g>f',     '<C-w>gf')
map({ 'x', 'n' }, '<M-g>F',     '<C-w>gF')
map({ 'x', 'n' }, '<M-g>t',     '<C-w>gt')
map({ 'x', 'n' }, '<M-g>T',     '<C-w>gT')
map({ 'x', 'n' }, '<M-w>',      '<C-w><C-w>')
map({ 'x', 'n' }, '<M-h>',      '<C-w><C-h>')
map({ 'x', 'n' }, '<M-j>',      '<C-w><C-j>')
map({ 'x', 'n' }, '<M-k>',      '<C-w><C-k>')
map({ 'x', 'n' }, '<M-l>',      '<C-w><C-l>')
map({ 'x', 'n' }, '<M-g><M-]>', '<C-w>g<C-]>')
map({ 'x', 'n' }, '<M-g><Tab>', '<C-w>g<Tab>')
-- stylua: ignore end

-- Terminal mode keymaps
-- stylua: ignore start
map('t', '<M-v>',      '<Cmd>wincmd v<CR>')
map('t', '<M-s>',      '<Cmd>wincmd s<CR>')
map('t', '<M-W>',      '<Cmd>wincmd W<CR>')
map('t', '<M-H>',      '<Cmd>wincmd H<CR>')
map('t', '<M-J>',      '<Cmd>wincmd J<CR>')
map('t', '<M-K>',      '<Cmd>wincmd K<CR>')
map('t', '<M-L>',      '<Cmd>wincmd L<CR>')
map('t', '<M-=>',      '<Cmd>wincmd =<CR>')
map('t', '<M-_>',      '<Cmd>wincmd _<CR>')
map('t', '<M-|>',      '<Cmd>wincmd |<CR>')
map('t', '<M->>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"', { expr = true })
map('t', '<M-<>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"', { expr = true })
map('t', '<M-.>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"', { expr = true })
map('t', '<M-,>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"', { expr = true })
map('t', '<M-+>',      '<Cmd>wincmd 2+<CR>')
map('t', '<M-->',      '<Cmd>wincmd 2-<CR>')
map('t', '<M-r>',      '<Cmd>wincmd r<CR>')
map('t', '<M-R>',      '<Cmd>wincmd R<CR>')
map('t', '<M-x>',      '<Cmd>wincmd x<CR>')
map('t', '<M-p>',      '<Cmd>wincmd p<CR>')
map('t', '<M-c>',      '<Cmd>wincmd c<CR>')
map('t', '<M-o>',      '<Cmd>wincmd o<CR>')
map('t', '<M-w>',      '<Cmd>wincmd w<CR>')
map('t', '<M-h>',      '<Cmd>wincmd h<CR>')
map('t', '<M-j>',      '<Cmd>wincmd j<CR>')
map('t', '<M-k>',      '<Cmd>wincmd k<CR>')
map('t', '<M-l>',      '<Cmd>wincmd l<CR>')
-- stylua: ignore end

-- Up/down motions
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })
map({ 'n', 'x' }, '<Down>', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, '<Up>', 'v:count ? "k" : "gk"', { expr = true })

-- Float terminals
map({ 'n', 't' }, '<M-Space>', function() utils.fterm(nil, {}) end)
map({ 'n', 't' }, '<M-i>', function() utils.fterm({ 'lazygit' }, {}) end)

-- Correct misspelled word / mark as correct
map('i', '<C-g>+', '<Esc>[szg`]a')
map('i', '<C-g>=', '<C-g>u<Esc>[s1z=`]a<C-G>u')

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
map('n', '<C-l>', function()
  return vim.v.hlsearch == 1 and '<Cmd>nohlsearch|diffupdate|echo<CR>'
    or '<Cmd>nohlsearch|diffupdate|normal! <C-l><CR>'
end, { expr = true })

-- Close all floating windows
map('n', '<Esc>', '<Cmd>fclose<CR>')

-- Select all file
map(
  'x',
  'af',
  ':<C-u>silent! keepjumps normal! ggVG<CR>',
  { silent = true, noremap = false }
)
