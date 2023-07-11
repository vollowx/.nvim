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
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 100,
  },
}
