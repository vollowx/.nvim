local dropbar = require 'dropbar'
local api = require 'dropbar.api'
local sources = require 'dropbar.sources'
local utils = require 'dropbar.utils'

dropbar.setup {
  general = {
    update_interval = 32,
    enable = function(buf, win)
      return vim.fn.win_gettype(win) == ''
        and vim.wo[win].winbar == ''
        and vim.bo[buf].bt == ''
        and (
          vim.bo[buf].ft == 'markdown'
          or require('utils').treesitter.is_active(buf)
        )
    end,
  },
  bar = {
    sources = function(buf)
      return vim.bo[buf].ft == 'markdown' and { sources.markdown }
        or {
          utils.source.fallback {
            sources.lsp,
            sources.treesitter,
          },
        }
    end,
  },
  sources = {
    path = {
      modified = function(sym)
        return sym:merge {
          icon = PREF.icons.ui.Circle,
          icon_hl = 'CmpItemKindSnippet',
        }
      end,
    },
  },
  icons = {
    kinds = { symbols = PREF.icons.kinds },
    bar = {
      separator = PREF.icons.ui.AngleRight,
      extends = PREF.icons.ui.Ellipsis,
    },
    ui = { menu = { indicator = PREF.icons.ui.AngleRight } },
  },
}

vim.keymap.set('n', '<Leader>;', api.pick)
vim.keymap.set('n', '[C', api.goto_context_start)
vim.keymap.set('n', ']C', api.select_next_context)
