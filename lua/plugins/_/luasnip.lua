local ls = require 'luasnip'
local ls_types = require 'luasnip.util.types'

ls.setup {
  history = true,
  region_check_events = 'CursorMoved,CursorMovedI',
  delete_check_events = 'TextChanged,TextChangedI',
  update_events = 'TextChanged,TextChangedI,InsertLeave',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
  ext_opts = {
    [ls_types.choiceNode] = {
      active = {
        virt_text = { { PREF.icons.kinds.Enum, 'Ochre' } },
      },
    },
    [ls_types.insertNode] = {
      active = {
        virt_text = { { PREF.icons.kinds.Snippet, 'Tea' } },
      },
    },
  },
}

vim.keymap.set({ 'n', 's' }, '<Tab>', function()
  if ls.jumpable(1) then
    ls.jump(1)
    return '<Ignore>'
  else
    return '<Tab>'
  end
end, { noremap = false, expr = true })
vim.keymap.set(
  { 'n', 's' },
  '<S-Tab>',
  function() ls.jump(-1) end,
  { noremap = false }
)
