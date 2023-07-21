local notify = require 'notify'
local icons = require('utils').static.icons

notify.setup {
  stages = 'fade',
  on_open = function(win)
    vim.api.nvim_set_option_value('winblend', 0, { scope = 'local', win = win })
    vim.api.nvim_win_set_config(win, { zindex = 90 })
  end,
  fps = 20,
  minimum_width = 50,
  level = 'INFO',
  icons = {
    ERROR = icons.DiagnosticsSignError,
    WARN = icons.DiagnosticsSignWarning,
    INFO = icons.DiagnosticsSignInformation,
    DEBUG = icons.Bug,
    TRACE = icons.Pencil,
  },
}

vim.notify = notify
