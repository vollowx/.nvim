local fn = vim.fn
local ls = require 'luasnip'
local ls_types = require 'luasnip.util.types'
local icons = require('utils.static').icons

---Load snippets for a given filetype
---@param ft string
local function load_snippets(ft)
  local snip_groups = require('snippets.' .. ft)
  for _, snip_group in pairs(snip_groups) do
    ls.add_snippets(ft, snip_group.snip or snip_group, snip_group.opts or {})
  end
end

local function lazy_load_snippets()
  local snippets_path = vim.split(fn.globpath(fn.stdpath 'config' .. '/lua/snippets', '*.lua'), '\n')
  vim.api.nvim_create_augroup('LuaSnipLazyLoadSnippets', { clear = true })
  for _, path in ipairs(snippets_path) do
    local ft = fn.fnamemodify(path, ':t:r')
    -- Load snippet immediately if ft matches the filetype of current buffer
    if ft == vim.bo.ft then load_snippets(ft) end
    vim.api.nvim_create_autocmd('FileType', {
      pattern = ft,
      once = true,
      group = 'LuaSnipLazyLoadSnippets',
      callback = function()
        load_snippets(ft)
        return true
      end,
    })
  end
end

local function set_keymap()
  vim.keymap.set({ 'n', 's' }, '<Tab>', function()
    if ls.jumpable(1) then
      ls.jump(1)
      return '<Ignore>'
    else
      return '<Tab>'
    end
  end, { noremap = false, expr = true })
  vim.keymap.set({ 'n', 's' }, '<S-Tab>', function() ls.jump(-1) end, { noremap = false })
  vim.keymap.set(
    's',
    '<C-n>',
    function() return ls.choice_active() and '<Plug>luasnip-next-choice' or '<C-n>' end,
    { silent = true, expr = true }
  )
  vim.keymap.set(
    's',
    '<C-p>',
    function() return ls.choice_active() and '<Plug>luasnip-prev-choice' or '<C-p>' end,
    { silent = true, expr = true }
  )
end

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
        virt_text = { { icons.Enum, 'Ochre' } },
      },
    },
    [ls_types.insertNode] = {
      active = {
        virt_text = { { icons.Snippet, 'Tea' } },
      },
    },
  },
}

lazy_load_snippets()
set_keymap()
