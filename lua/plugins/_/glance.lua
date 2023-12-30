local glance = require 'glance'
local actions = glance.actions
local horiz = vim.opt.fillchars:get().horiz

glance.setup {
  height = 16,
  detached = function(win) return vim.api.nvim_win_get_width(win) < 80 end,
  folds = {
    fold_closed = PREF.icons.ui.AngleRight,
    fold_open = PREF.icons.ui.AngleDown,
  },
  indent_lines = {
    enable = true,
    icon = ' ',
  },
  theme = { enable = false },
  border = {
    enable = PREF.ui.show_peek_border,
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
      ['<M-s>'] = actions.jump_split,
      ['<M-t>'] = actions.jump_tab,
      ['<M-q>'] = actions.quickfix,
      ['<CR>'] = actions.jump,
      ['zo'] = actions.open_fold,
      ['zc'] = actions.close_fold,
      ['za'] = actions.toggle_fold,

      ['<C-w><C-h>'] = actions.enter_win 'preview',
      ['<C-w><C-p>'] = actions.enter_win 'preview',
      ['<C-w><C-w>'] = actions.enter_win 'preview',
      ['<C-w>h'] = actions.enter_win 'preview',
      ['<C-w>p'] = actions.enter_win 'preview',
      ['<C-w>w'] = actions.enter_win 'preview',
      ['<M-h>'] = actions.enter_win 'preview',
      ['<M-p>'] = actions.enter_win 'preview',
      ['<M-w>'] = actions.enter_win 'preview',

      ['<C-w>+'] = '<Ignore>',
      ['<C-w>,'] = '<Ignore>',
      ['<C-w>-'] = '<Ignore>',
      ['<C-w>.'] = '<Ignore>',
      ['<C-w><'] = '<Ignore>',
      ['<C-w><C-j>'] = '<Ignore>',
      ['<C-w><C-k>'] = '<Ignore>',
      ['<C-w><C-l>'] = '<Ignore>',
      ['<C-w><C-s>'] = '<Ignore>',
      ['<C-w><C-v>'] = '<Ignore>',
      ['<C-w>>'] = '<Ignore>',
      ['<C-w>_'] = '<Ignore>',
      ['<C-w>j'] = '<Ignore>',
      ['<C-w>k'] = '<Ignore>',
      ['<C-w>l'] = '<Ignore>',
      ['<C-w>s'] = '<Ignore>',
      ['<C-w>v'] = '<Ignore>',
      ['<C-w>|'] = '<Ignore>',
      ['<M-+>'] = '<Ignore>',
      ['<M-,>'] = '<Ignore>',
      ['<M-->'] = '<Ignore>',
      ['<M-.>'] = '<Ignore>',
      ['<M-<>'] = '<Ignore>',
      ['<M->>'] = '<Ignore>',
      ['<M-_>'] = '<Ignore>',
      ['<M-j>'] = '<Ignore>',
      ['<M-k>'] = '<Ignore>',
      ['<M-l>'] = '<Ignore>',
      ['<M-|>'] = '<Ignore>',

      ['<S-Tab>'] = false,
      ['v'] = false,
      ['s'] = false,
      ['t'] = false,
      ['l'] = false,
      ['h'] = false,
      ['q'] = false,
      ['Q'] = false,
      ['o'] = false,
      ['<Leader>l'] = false,
    },
    ---@type table<string, function|boolean>
    preview = {
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,

      ['<C-w><C-l>'] = actions.enter_win 'list',
      ['<C-w><C-p>'] = actions.enter_win 'list',
      ['<C-w><C-w>'] = actions.enter_win 'list',
      ['<C-w>l'] = actions.enter_win 'list',
      ['<C-w>p'] = actions.enter_win 'list',
      ['<C-w>w'] = actions.enter_win 'list',
      ['<M-l>'] = actions.enter_win 'list',
      ['<M-p>'] = actions.enter_win 'list',
      ['<M-w>'] = actions.enter_win 'list',

      ['<C-w>+'] = '<Ignore>',
      ['<C-w>,'] = '<Ignore>',
      ['<C-w>-'] = '<Ignore>',
      ['<C-w>.'] = '<Ignore>',
      ['<C-w><'] = '<Ignore>',
      ['<C-w><C-h>'] = '<Ignore>',
      ['<C-w><C-j>'] = '<Ignore>',
      ['<C-w><C-k>'] = '<Ignore>',
      ['<C-w><C-s>'] = '<Ignore>',
      ['<C-w><C-v>'] = '<Ignore>',
      ['<C-w>>'] = '<Ignore>',
      ['<C-w>_'] = '<Ignore>',
      ['<C-w>h'] = '<Ignore>',
      ['<C-w>j'] = '<Ignore>',
      ['<C-w>k'] = '<Ignore>',
      ['<C-w>s'] = '<Ignore>',
      ['<C-w>v'] = '<Ignore>',
      ['<C-w>|'] = '<Ignore>',
      ['<M-+>'] = '<Ignore>',
      ['<M-,>'] = '<Ignore>',
      ['<M-->'] = '<Ignore>',
      ['<M-.>'] = '<Ignore>',
      ['<M-<>'] = '<Ignore>',
      ['<M->>'] = '<Ignore>',
      ['<M-_>'] = '<Ignore>',
      ['<M-h>'] = '<Ignore>',
      ['<M-j>'] = '<Ignore>',
      ['<M-k>'] = '<Ignore>',
      ['<M-s>'] = '<Ignore>',
      ['<M-v>'] = '<Ignore>',
      ['<M-|>'] = '<Ignore>',

      ['q'] = false,
      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
    },
  },
}

---@diagnostic disable: duplicate-set-field
-- Override LSP handler functions
-- stylua: ignore start
vim.lsp.buf.references = function() glance.open('references') end
vim.lsp.buf.definition = function() glance.open('definitions') end
vim.lsp.buf.type_definition = function() glance.open('type_definitions') end
vim.lsp.buf.implementations = function() glance.open('implementations') end
-- stylua: ignore end
---@diagnostic enable: duplicate-set-field
