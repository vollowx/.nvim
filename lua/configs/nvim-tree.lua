local border = require('core.settings').border
local icons = require('utils.static').icons

require('nvim-tree').setup {
  disable_netrw = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  filters = { git_ignored = false },
  view = {
    preserve_window_proportions = true,
    float = {
      enable = true,
      open_win_config = {
        border = border,
        col = 2,
      },
    },
  },
  renderer = {
    highlight_git = true,
    icons = {
      git_placement = 'signcolumn',
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
          unstaged = vim.trim(icons.git.Mod),
          staged = vim.trim(icons.git.Add),
          unmerged = vim.trim(icons.git.Unmerged),
          renamed = vim.trim(icons.git.Rename),

          untracked = vim.trim(icons.git.Untracked),
          deleted = vim.trim(icons.git.Remove),
          ignored = vim.trim(icons.ui.CircleUnfilled),
        },
      },
    },
  },
}
