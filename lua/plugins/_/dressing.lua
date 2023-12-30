require('dressing').setup {
  input = {
    border = PREF.ui.border_interactive,
    override = function(conf)
      conf.col = -1
      conf.row = 0
      return conf
    end,
  },
  select = {
    backend = 'builtin',
    builtin = {
      border = PREF.ui.border_interactive,
      relative = 'cursor',
      min_height = { 0, 0 },
    },
  },
}
