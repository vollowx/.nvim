local icons = require('utils.static').icons

require('todo-comments').setup {
  keywords = {
    FIX = {
      icon = icons.ui.Bug,
      color = 'error',
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
    },
    TODO = { icon = icons.ui.Check, color = 'info' },
    HACK = { icon = icons.ui.Ghost, color = 'warning' },
    WARN = { icon = icons.diagnostics.DiagnosticSignWarn, color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = icons.ui.ClockFast, alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = icons.ui.Note, color = 'hint', alt = { 'INFO' } },
    TEST = { icon = icons.ui.Flag, color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
}
