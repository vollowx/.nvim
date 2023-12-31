require('gitsigns').setup {
  preview_config = {
    border = PREF.ui.border_hover,
    style = 'minimal',
  },
  signs = {
    add = { text = vim.trim(PREF.icons.ui.GitSignAdd) },
    untracked = { text = vim.trim(PREF.icons.ui.GitSignUntracked) },
    change = { text = vim.trim(PREF.icons.ui.GitSignChange) },
    delete = { text = vim.trim(PREF.icons.ui.GitSignDelete) },
    topdelete = { text = vim.trim(PREF.icons.ui.GitSignTopdelete) },
    changedelete = { text = vim.trim(PREF.icons.ui.GitSignChangedelete) },
  },
  signcolumn = PREF.git.show_signcolumn,
  current_line_blame = PREF.git.show_blame,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 500,
  },
}
