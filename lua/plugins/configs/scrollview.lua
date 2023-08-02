local icons = require('utils.static').icons

require('scrollview').setup {
  floating_windows = true,
  mode = 'visual',
  winblend = require('core.settings').transparent and 0 or 50,
  signs_on_startup = { 'diagnostics', 'folds', 'marks', 'search', 'spell' },
  diagnostics_error_symbol = icons.diagnostics.DiagnosticSignError,
  diagnostics_warn_symbol = icons.diagnostics.DiagnosticSignWarn,
  diagnostics_info_symbol = icons.diagnostics.DiagnosticSignInfo,
  diagnostics_hint_symbol = icons.diagnostics.DiagnosticSignHint,
}
