local icons = require('utils.static').icons

require('nvim-tree').setup {
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  filters = {
    git_ignored = false,
  },
  renderer = {
    highlight_git = true,

    icons = {
      git_placement = 'after',
      symlink_arrow = ' ' .. icons.ui.ArrowRight,
      glyphs = {
        default = vim.trim(icons.kinds.File),
        symlink = vim.trim(icons.ui.AngleRight),
        bookmark = vim.trim(icons.ui.Diamond),
        folder = {
          arrow_closed = vim.trim(icons.ui.AngleRight),
          arrow_open = vim.trim(icons.ui.AngleDown),
          default = vim.trim(icons.kinds.Folder),
          open = vim.trim(icons.ui.FolderOpen),
          empty = vim.trim(icons.ui.FolderEmpty),
          empty_open = vim.trim(icons.ui.FolderEmptyOpen),
          symlink = vim.trim(icons.ui.FolderLink),
          symlink_open = vim.trim(icons.ui.FolderOpen),
        },
        git = {
          unstaged = icons.git.Mod,
          staged = icons.git.Add,
          unmerged = icons.git.Unmerged,
          renamed = icons.git.Rename, --󰁔
          untracked = icons.git.Untracked,
          deleted = icons.git.Remove,
          ignored = icons.ui.CircleUnfilled,
        },
      },
    },
  },
}
