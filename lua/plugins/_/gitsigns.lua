require('gitsigns').setup {
  preview_config = {
    border = PREF.ui.hover_border,
    style = 'minimal',
  },
  signs = {
    add = { text = '▍' },
    untracked = { text = '▍' },
    change = { text = '▍' },
    delete = { text = '▁' },
    topdelete = { text = '▔' },
    changedelete = { text = '▍' },
  },
  signcolumn = PREF.git.show_signcolumn,
  current_line_blame = PREF.git.show_blame,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 500,
  },
}
