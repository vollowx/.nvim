require('nvim-tree').setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,

    icons = {
      git_placement = "after"
    },
  },
})

local keymap = require('utils').keymap
keymap.set('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', keymap.opt { desc = 'ui: Toggle file tree' })
