local border = require('core.settings').border

require('gitsigns').setup {
  preview_config = {
    border = border,
    style = 'minimal',
  },
  signs = {
    add = { text = '▎' },
    untracked = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '▎' },
    topdelete = { text = '▎' },
    changedelete = { text = '▎' },
  },
}
