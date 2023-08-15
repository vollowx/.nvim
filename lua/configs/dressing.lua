local border = require('core.settings').border
require('dressing').setup {
  input = {
    border = border,
    win_options = {
      winblend = 0,
    },
  },
  select = {
    backend = 'builtin',
    builtin = {
      border = border,
      relative = 'cursor',
      win_options = {
        winblend = 0,
      },
      min_height = { 0, 0 },
    },
    format_item_override = {
      codeaction = function(action_tuple)
        local title = action_tuple[2].title:gsub('\r\n', '\\r\\n')
        local client = vim.lsp.get_client_by_id(action_tuple[1])
        return string.format('%s [%s]', title:gsub('\n', '\\n'), client.name)
      end,
    },
  },
}
