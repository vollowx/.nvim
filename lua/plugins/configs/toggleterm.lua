local toggleterm = require 'toggleterm'

toggleterm.setup {
  open_mapping = '<C-\\><C-\\>',
  shade_terminals = false,
  start_in_insert = true,
  hide_numbers = true,
  autochdir = false,
  persist_size = false,
  direction = 'horizontal',
  float_opts = {
    border = 'single',
    width = function() return math.floor(vim.go.columns * 0.7) end,
    height = function() return math.floor(vim.go.lines * 0.7) end,
    winblend = 0,
  },
  size = function(term)
    if term.direction == 'horizontal' then
      return vim.go.lines * 0.3
    elseif term.direction == 'vertical' then
      return vim.go.columns * 0.35
    end
  end,
  highlights = {
    NormalFloat = { link = 'NormalFloat' },
    FloatBorder = { link = 'FloatBorder' },
    WinBarActive = { link = 'WinBar' },
    WinBarInactive = { link = 'WinBarNC' },
    MatchParen = { link = 'None' },
    StatusLine = { link = 'StatusLine' },
  },
  winbar = {
    enabled = false,
  },
  on_open = function() vim.cmd 'silent! normal! 0' end,
}
