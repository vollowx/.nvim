require('nvim-tree').setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  renderer = {
    highlight_git = true,

    icons = {
      git_placement = 'after'
    },
  },
})

local map = require('utils').keymap.set
map('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', { desc = 'ui: Toggle file tree' })
