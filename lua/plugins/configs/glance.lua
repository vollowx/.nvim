local glance = require('glance')
local actions = glance.actions
local utils = require('utils')
local horiz = vim.opt.fillchars:get().horiz

glance.setup({
  height = 16,
  detached = function(win)
    return vim.api.nvim_win_get_width(win) < 80
  end,
  folds = {
    fold_closed = utils.static.icons.AngleRight,
    fold_open = utils.static.icons.AngleDown,
  },
  indent_lines = {
    enable = true,
    icon = ' ',
  },
  theme = {
    enable = false,
  },
  border = {
    enable = true,
    top_char = horiz,
    bottom_char = horiz,
  },
  hooks = {
    before_open = function(results, open, jump)
      if #results == 0 then
        vim.notify('[glance.nvim] no results found', vim.log.levels.INFO)
        return
      end
      if #results > 1 then
        open(results)
        return
      end
      -- Only one result
      vim.notify('[glance.nvim] only one result found', vim.log.levels.INFO)
      jump(results[1])
    end,
  },
  mappings = {
    ---@type table<string, function|boolean>
    list = {
      ['j'] = actions.next,
      ['k'] = actions.previous,
      ['<Down>'] = actions.next,
      ['<Up>'] = actions.previous,
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,
      ['<C-u>'] = actions.preview_scroll_win(5),
      ['<C-d>'] = actions.preview_scroll_win(-5),
      ['<C-f>'] = actions.preview_scroll_win(10),
      ['<C-b>'] = actions.preview_scroll_win(-10),
      ['<M-v>'] = actions.jump_vsplit,
      ['<C-v>'] = actions.jump_vsplit,
      ['<M-s>'] = actions.jump_split,
      ['<C-s>'] = actions.jump_split,
      ['<M-t>'] = actions.jump_tab,
      ['<C-t>'] = actions.jump_tab,
      ['<M-q>'] = actions.quickfix,
      ['<C-q>'] = actions.quickfix,
      ['zo'] = actions.open_fold,
      ['zc'] = actions.close_fold,
      ['za'] = actions.toggle_fold,
      ['<Tab>'] = actions.toggle_fold,
      ['<CR>'] = actions.jump,
      ['<C-w>h'] = actions.enter_win('preview'),
      ['<M-h>'] = actions.enter_win('preview'),
      ['q'] = actions.close,
      ['<Esc>'] = actions.close,
      ['<S-Tab>'] = false,
      ['v'] = false,
      ['s'] = false,
      ['t'] = false,
      ['l'] = false,
      ['h'] = false,
      ['Q'] = false,
      ['o'] = false,
      ['<Leader>l'] = false,
    },
    ---@type table<string, function|boolean>
    preview = {
      ['q'] = actions.close,
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,
      ['<C-w>l'] = actions.enter_win('list'),
      ['<M-l>'] = actions.enter_win('list'),
      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
    },
  },
})

---@diagnostic disable: duplicate-set-field
-- Override LSP handler functions
-- stylua: ignore start
vim.lsp.buf.references = function() glance.open('references') end
vim.lsp.buf.definition = function() glance.open('definitions') end
vim.lsp.buf.type_definition = function() glance.open('type_definitions') end
vim.lsp.buf.implementations = function() glance.open('implementations') end
-- stylua: ignore end
---@diagnostic enable: duplicate-set-field
