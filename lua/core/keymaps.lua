vim.keymap.set({ 'n', 'x' }, '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Esc>', '<Cmd>noh<CR>', { desc = 'search: Clear highlights' })
vim.keymap.set('n', '<C-s>', '<Cmd>write<CR>', { desc = 'edit: Write to file' })

-- Multi-window operations
vim.keymap.set({ 'n', 'x' }, '<C-h>', '<C-w>h', { desc = 'window: Go left' })
vim.keymap.set({ 'n', 'x' }, '<C-j>', '<C-w>j', { desc = 'window: Go down' })
vim.keymap.set({ 'n', 'x' }, '<C-k>', '<C-w>k', { desc = 'window: Go up' })
vim.keymap.set({ 'n', 'x' }, '<C-l>', '<C-w>l', { desc = 'window: Go right' })

-- Up/down motions
vim.keymap.set({ 'n', 'x', 'o' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'k', 'v:count ? "k" : "gk"', { expr = true })

-- Indent
vim.keymap.set({ 'x', 'o' }, '>', '>gv', { desc = 'edit: Increase indent' })
vim.keymap.set({ 'x', 'o' }, '<', '<gv', { desc = 'edit: Decrease indent' })

-- Buffer navigation
vim.keymap.set('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
vim.keymap.set('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')

-- Correct misspelled word / mark as correct
vim.keymap.set('i', '<C-S-L>', '<Esc>[szg`]a')
vim.keymap.set('i', '<C-l>', '<C-G>u<Esc>[s1z=`]a<C-G>u')

-- Close all floating windows
vim.keymap.set('n', 'q', function()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    -- close floating windows that can be focused
    if config.relative ~= '' and config.focusable then
      vim.api.nvim_win_close(win, false) -- do not force
      count = count + 1
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('q', true, true, true), 'n', false)
  end
end, { desc = 'window: Close floating windows' })

vim.keymap.set(
  't',
  '<C-x>',
  vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
  { desc = 'terminal: Exit terminal mode' }
)
