local builtin = require 'statuscol.builtin'

require('statuscol').setup {
  relculright = true,
  bt_ignore = { 'nofile', 'prompt', 'terminal' },
  ft_ignore = {
    'NvimTree',
    'help',
    'vim',
    'lazy',
  },
  segments = {
    {
      text = { ' ', builtin.foldfunc },
      click = 'v:lua.ScFa',
    },
    {
      text = { ' ', builtin.lnumfunc, ' ' },
      click = 'v:lua.ScLa',
    },
    {
      sign = { name = { 'GitSigns' }, maxwidth = 1, colwidth = 1 },
    },
    { text = { ' ' } },
  },
}
