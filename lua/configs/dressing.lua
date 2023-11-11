require('dressing').setup {
  input = {
    border = 'solid',
    win_options = {
      winblend = 0,
    },
  },
  select = {
    backend = 'builtin',
    builtin = {
      border = 'solid',
      relative = 'cursor',
      win_options = {
        winblend = 0,
      },
      min_height = { 0, 0 },
    },
  },
}
