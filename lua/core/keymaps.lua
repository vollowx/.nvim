local keymap = require('utils').keymap
local set = keymap.set
local opt = keymap.opt

set('nx', '<Space>', '<Ignore>', opt())
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

set('n', '<Esc>', '<Cmd>noh<CR>', opt { desc = 'search: No highlight' })
set('n', '<C-s>', '<Cmd>write<CR>', opt { desc = 'buffer: Save file' })

-- Multi-window operations
set('nx', '<C-h>', '<C-w>h', opt { desc = 'window: Go left' })
set('nx', '<C-j>', '<C-w>j', opt { desc = 'window: Go down' })
set('nx', '<C-k>', '<C-w>k', opt { desc = 'window: Go up' })
set('nx', '<C-l>', '<C-w>l', opt { desc = 'window: Go right' })

-- Up/down motions
set('nx', 'j', 'v:count ? "j" : "gj"', opt { expr = true })
set('nx', 'k', 'v:count ? "k" : "gk"', opt { expr = true })

-- Buffer navigation
set('n', '<A-j>', '<Cmd>exec v:count1 . "bn"<CR>', opt { desc = 'buffer: Next buffer' })
set('n', '<A-k>', '<Cmd>exec v:count1 . "bp"<CR>', opt { desc = 'buffer: Previous buffer' })

-- Close all floating windows
set('n', 'q', '<Ignore>', opt { desc = 'window: Close floating windows', callback = function()
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
end })

set('t', '<C-Esc>', vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), opt { desc = 'terminal: Exit terminal mode' })
set('n', '<A-f>', '<Ignore>', opt { desc = 'lsp: Format', callback = function()
  vim.lsp.buf.format { async = true }
end, expr = true })
