local map = require('utils').keymap.set

map('nx', '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map('n', '<Esc>', '<Cmd>noh<CR>', { desc = 'search: No highlight' })
map('n', '<C-s>', '<Cmd>write<CR>', { desc = 'buffer: Save file' })

-- Multi-window operations
map('nx', '<C-h>', '<C-w>h', { desc = 'window: Go left' })
map('nx', '<C-j>', '<C-w>j', { desc = 'window: Go down' })
map('nx', '<C-k>', '<C-w>k', { desc = 'window: Go up' })
map('nx', '<C-l>', '<C-w>l', { desc = 'window: Go right' })

-- Up/down motions
map('nx', 'j', 'v:count ? "j" : "gj"', { expr = true })
map('nx', 'k', 'v:count ? "k" : "gk"', { expr = true })

-- Buffer navigation
map('n', '<A-q>', '<Cmd>bd<CR>', { desc = 'buffer: Delete buffer' })
map('n', '<A-j>', '<Cmd>exec v:count1 . "bn"<CR>', { desc = 'buffer: Next buffer' })
map('n', '<A-k>', '<Cmd>exec v:count1 . "bp"<CR>', { desc = 'buffer: Previous buffer' })

-- Close all floating windows
map('n', 'q', function()
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
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('q', true, true, true),
      'n',
      false
    )
  end
end, { desc = 'window: Close floating windows' })

map('t', '<C-Esc>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true), { desc = 'terminal: Exit terminal mode' })
map('n', '<A-f>', function()
  vim.lsp.buf.format { async = true }
end, { desc = 'lsp: Format', expr = true })
