local static = require 'utils.static'
local dropbar = require 'dropbar'

dropbar.setup {
  general = {
    update_interval = 64,
    update_events = {
      tab = {
        'WinResized',
      },
    },
  },
  bar = {
    padding = {
      left = 2,
      right = 2,
    },
  },
  sources = {
    path = {
      modified = function(sym)
        return sym:merge {
          icon = static.icons.ui.DotLarge,
          icon_hl = 'CmpItemKindSnippet',
        }
      end,
    },
  },
}
