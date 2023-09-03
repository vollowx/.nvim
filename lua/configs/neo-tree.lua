local border = require('core.settings').border
local icons = require('utils.static').icons

require('neo-tree').setup {
  popup_border_style = border,
  default_component_configs = {
    icon = {
      folder_closed = vim.trim(icons.kinds.Folder),
      folder_open = vim.trim(icons.ui.FolderOpen),
      folder_empty = vim.trim(icons.ui.FolderEmpty),
    },
    modified = { symbol = vim.trim(icons.ui.CircleSmall) },
    git_status = {
      symbols = {
        added = vim.trim(icons.git.Add),
        modified = vim.trim(icons.git.Mod),
        deleted = vim.trim(icons.git.Remove),
        renamed = vim.trim(icons.git.Rename),

        untracked = vim.trim(icons.git.Untracked),
        ignored = vim.trim(icons.ui.CircleUnfilled),
        unstaged = vim.trim(icons.ui.Cross),
        staged = vim.trim(icons.ui.Check),
        conflict = vim.trim(icons.git.Unmerged),
      },
    },
  },
  window = {
    width = 36,

    mappings = {
      ['<Space>'] = 'noop',
      ['oc'] = 'noop',
      ['od'] = 'noop',
      ['og'] = 'noop',
      ['on'] = 'noop',
      ['om'] = 'noop',
      ['os'] = 'noop',
      ['ot'] = 'noop',

      ['o'] = 'open',
    },
  },
  filesystem = {
    bind_to_cwd = true,
    filtered_items = { visible = true, hide_dotfiles = false },
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
}
