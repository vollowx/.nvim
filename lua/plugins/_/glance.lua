local actions = require('glance').actions

require('glance').setup {
  folds = {
    fold_closed = PREF.icons.ui.AngleRight,
    fold_open = PREF.icons.ui.AngleDown,
  },
  theme = { mode = 'darken' },
  hooks = {
    before_open = function(results, open, _, method)
      if #results == 0 then
        vim.notify '[glance] this method is not supported by any of the servers registered for the current buffer'
      elseif #results == 1 and method == 'references' then
        vim.notify '[glance] the identifier under cursor is the only one found'
      else
        open(results)
      end
    end,
  },
  mappings = {
    ---@type table<string, function|boolean>
    list = {
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,
      ['sh'] = actions.enter_win 'preview',
      ['sv'] = actions.jump_vsplit,
      ['ss'] = actions.jump_split,
      ['s+'] = actions.jump_tab,

      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
      ['v'] = false,
      ['s'] = false,
      ['t'] = false,
    },
    ---@type table<string, function|boolean>
    preview = {
      ['q'] = actions.close,
      ['<C-n>'] = actions.next_location,
      ['<C-p>'] = actions.previous_location,
      ['sl'] = actions.enter_win 'list',

      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
    },
  },
}
