local glance = require 'glance'
local actions = glance.actions
local icons = require('utils.static').icons
local horiz = vim.opt.fillchars:get().horiz

glance.setup {
  height = 20,
  zindex = 50,
  theme = {
    mode = 'darken',
  },
  folds = {
    fold_closed = icons.AngleRight,
    fold_open = icons.AngleDown,
  },
  border = {
    enable = require('core.settings').transparent,
    top_char = horiz,
    bottom_char = horiz,
  },
  hooks = {
    before_open = function(results, open, jump)
      if #results == 0 then
        vim.notify('[glance.nvim] No results found', vim.log.levels.INFO)
        return
      end
      if #results > 1 then
        open(results)
        return
      end
      -- Only one result
      vim.notify('[glance.nvim] Only one result found', vim.log.levels.INFO)
      jump(results[1])
    end,
  },
  mappings = {
    ---@type table<string, function|boolean>
    list = {
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,
      ['<C-f>'] = actions.preview_scroll_win(10),
      ['<C-b>'] = actions.preview_scroll_win(-10),
      ['gq'] = actions.quickfix,
      ['<C-h>'] = actions.enter_win 'preview',
      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
    },
    ---@type table<string, function|boolean>
    preview = {
      ['q'] = actions.close,
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,
      ['<C-l>'] = actions.enter_win 'list',
      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
    },
  },
}

-- Override LSP handler functions
-- stylua: ignore start
vim.lsp.buf.references = function() glance.open('references') end
vim.lsp.buf.definition = function() glance.open('definitions') end
vim.lsp.buf.type_definition = function() glance.open('type_definitions') end
vim.lsp.buf.implementations = function() glance.open('implementations') end
-- stylua: ignore end
