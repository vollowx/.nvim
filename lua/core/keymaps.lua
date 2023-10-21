vim.keymap.set({ 'n', 'x' }, '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Multi-window operations
-- stylua: ignore start
vim.keymap.set({ 'x', 'n' }, '<M-W>',      '<C-w>W')
vim.keymap.set({ 'x', 'n' }, '<M-H>',      '<C-w>H')
vim.keymap.set({ 'x', 'n' }, '<M-J>',      '<C-w>J')
vim.keymap.set({ 'x', 'n' }, '<M-K>',      '<C-w>K')
vim.keymap.set({ 'x', 'n' }, '<M-L>',      '<C-w>L')
vim.keymap.set({ 'x', 'n' }, '<M-=>',      '<C-w>=')
vim.keymap.set({ 'x', 'n' }, '<M-_>',      '<C-w>_')
vim.keymap.set({ 'x', 'n' }, '<M-|>',      '<C-w>|')
vim.keymap.set({ 'x', 'n' }, '<M->>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-<>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-.>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-,>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-+>',      'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-->',      'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-p>',      '<C-w>p')
vim.keymap.set({ 'x', 'n' }, '<M-r>',      '<C-w>r')
vim.keymap.set({ 'x', 'n' }, '<M-v>',      '<C-w>v')
vim.keymap.set({ 'x', 'n' }, '<M-s>',      '<C-w>s')
vim.keymap.set({ 'x', 'n' }, '<M-x>',      '<C-w>x')
vim.keymap.set({ 'x', 'n' }, '<M-z>',      '<C-w>z')
vim.keymap.set({ 'x', 'n' }, '<M-c>',      '<C-w>c')
vim.keymap.set({ 'x', 'n' }, '<M-n>',      '<C-w>n')
vim.keymap.set({ 'x', 'n' }, '<M-o>',      '<C-w>o')
vim.keymap.set({ 'x', 'n' }, '<M-t>',      '<C-w>t')
vim.keymap.set({ 'x', 'n' }, '<M-T>',      '<C-w>T')
vim.keymap.set({ 'x', 'n' }, '<M-]>',      '<C-w>]')
vim.keymap.set({ 'x', 'n' }, '<M-^>',      '<C-w>^')
vim.keymap.set({ 'x', 'n' }, '<M-b>',      '<C-w>b')
vim.keymap.set({ 'x', 'n' }, '<M-d>',      '<C-w>d')
vim.keymap.set({ 'x', 'n' }, '<M-f>',      '<C-w>f')
vim.keymap.set({ 'x', 'n' }, '<M-}>',      '<C-w>}')
vim.keymap.set({ 'x', 'n' }, '<M-g>]',     '<C-w>g]')
vim.keymap.set({ 'x', 'n' }, '<M-g>}',     '<C-w>g}')
vim.keymap.set({ 'x', 'n' }, '<M-g>f',     '<C-w>gf')
vim.keymap.set({ 'x', 'n' }, '<M-g>F',     '<C-w>gF')
vim.keymap.set({ 'x', 'n' }, '<M-g>t',     '<C-w>gt')
vim.keymap.set({ 'x', 'n' }, '<M-g>T',     '<C-w>gT')
vim.keymap.set({ 'x', 'n' }, '<M-w>',      '<C-w><C-w>')
vim.keymap.set({ 'x', 'n' }, '<M-h>',      '<C-w><C-h>')
vim.keymap.set({ 'x', 'n' }, '<M-j>',      '<C-w><C-j>')
vim.keymap.set({ 'x', 'n' }, '<M-k>',      '<C-w><C-k>')
vim.keymap.set({ 'x', 'n' }, '<M-l>',      '<C-w><C-l>')
vim.keymap.set({ 'x', 'n' }, '<M-g><M-]>', '<C-w>g<C-]>')
vim.keymap.set({ 'x', 'n' }, '<M-g><Tab>', '<C-w>g<Tab>')

vim.keymap.set({ 'x', 'n' }, '<C-w>>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w><', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>,', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>.', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
-- stylua: ignore end

-- Up/down motions
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })

-- Buffer navigation
vim.keymap.set('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
vim.keymap.set('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')

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
vim.keymap.set('n', 'gt', tabswitch(vim.cmd.tabnext))
vim.keymap.set('n', 'gT', tabswitch(vim.cmd.tabprev))
vim.keymap.set('n', 'gy', tabswitch(vim.cmd.tabprev)) -- gT is too hard to press

vim.keymap.set('n', '<M-1>', tabswitch(vim.cmd.tabnext, 1))
vim.keymap.set('n', '<M-2>', tabswitch(vim.cmd.tabnext, 2))
vim.keymap.set('n', '<M-3>', tabswitch(vim.cmd.tabnext, 3))
vim.keymap.set('n', '<M-4>', tabswitch(vim.cmd.tabnext, 4))
vim.keymap.set('n', '<M-5>', tabswitch(vim.cmd.tabnext, 5))
vim.keymap.set('n', '<M-6>', tabswitch(vim.cmd.tabnext, 6))
vim.keymap.set('n', '<M-7>', tabswitch(vim.cmd.tabnext, 7))
vim.keymap.set('n', '<M-8>', tabswitch(vim.cmd.tabnext, 8))
vim.keymap.set('n', '<M-9>', tabswitch(vim.cmd.tabnext, 9))

-- Correct misspelled word / mark as correct
vim.keymap.set('i', '<C-S-L>', '<Esc>[szg`]a')
vim.keymap.set('i', '<C-l>', '<C-G>u<Esc>[s1z=`]a<C-G>u')

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
vim.keymap.set(
  'n',
  '<C-l>',
  function()
    return vim.v.hlsearch == 1 and '<Cmd>nohlsearch<Bar>diffupdate<Bar>echo<CR>'
      or '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-l><CR>'
  end,
  { expr = true }
)

-- Don't include extra spaces around quotes
vim.keymap.set({ 'o', 'x' }, 'a"', '2i"', { noremap = false })
vim.keymap.set({ 'o', 'x' }, "a'", "2i'", { noremap = false })
vim.keymap.set({ 'o', 'x' }, 'a`', '2i`', { noremap = false })

-- Close all floating windows
vim.keymap.set('n', 'q', '<Cmd>fclose<CR>')

-- Text object: current buffer
-- stylua: ignore start
vim.keymap.set('x', 'af', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
vim.keymap.set('x', 'if', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- stylua: ignore end
