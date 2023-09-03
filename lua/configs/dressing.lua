local border = require('core.settings').border

require('dressing').setup {
  input = {
    border = border,
    win_options = {
      winblend = 0,
    },
  },
  select = {
    backend = 'builtin',
    builtin = {
      border = border,
      relative = 'cursor',
      win_options = {
        winblend = 0,
      },
      min_height = { 0, 0 },
    },
  },
}
