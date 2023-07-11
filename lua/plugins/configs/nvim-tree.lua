local icons = require('utils').static.icons

require('nvim-tree').setup {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  renderer = {
    highlight_git = true,

    icons = {
      git_placement = 'after',

      glyphs = {
        default = vim.trim(icons.File)
      }
    },
  },
}
