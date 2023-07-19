local icons = require('utils.static').icons

require('scrollview').setup {
  winblend = 0,
  floating_windows = true,
  signs_on_startup = { 'all' },
  diagnostics_error_symbol = icons.DiagnosticSignError,
  diagnostics_warn_symbol = icons.DiagnosticSignWarning,
  diagnostics_info_symbol = icons.DiagnosticSignInfo,
  diagnostics_hint_symbol = icons.DiagnosticSignHint,
}
