local icons = require('utils.static').icons

require('scrollview').setup {
  floating_windows = true,
  winblend = 0,
  signs_on_startup = { 'diagnostics', 'folds', 'marks', 'search', 'spell' },
  diagnostics_error_symbol = icons.DiagnosticSignError,
  diagnostics_warn_symbol = icons.DiagnosticSignWarning,
  diagnostics_info_symbol = icons.DiagnosticSignInfo,
  diagnostics_hint_symbol = icons.DiagnosticSignHint,
}
