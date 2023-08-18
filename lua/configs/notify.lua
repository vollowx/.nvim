local notify = require 'notify'
local icons = require('utils.static').icons

notify.setup {
  stages = 'fade',
  fps = 20,
  minimum_width = 50,
  level = 'INFO',
  icons = {
    ERROR = icons.diagnostics.Error,
    WARN = icons.diagnostics.Warning,
    INFO = icons.diagnostics.Information,
    DEBUG = icons.ui.Bug,
    TRACE = icons.ui.Pencil,
  },
}

vim.notify = notify
