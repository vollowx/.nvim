require('dressing').setup {
  input = {
    border = PREF.ui.interactive_border,
    override = function(conf)
      conf.col = -1
      conf.row = 0
      return conf
    end,
  },
  select = {
    backend = 'builtin',
    builtin = {
      border = PREF.ui.interactive_border,
      relative = 'cursor',
      min_height = { 0, 0 },
    },
  },
}
