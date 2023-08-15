local notify = require 'notify'
local icons = require('utils.static').icons

notify.setup {
  stages = 'fade',
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
