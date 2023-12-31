local fn = vim.fn
local ls = require 'luasnip'
local ls_types = require 'luasnip.util.types'

---Load snippets for a given filetype
---@param ft string
---@return nil
local function load_snippets(ft)
  local ok, snip_groups = pcall(require, 'snippets.' .. ft)
  if ok and type(snip_groups) == 'table' then
    for _, snip_group in pairs(snip_groups) do
      ls.add_snippets(ft, snip_group.snip or snip_group, snip_group.opts or {})
    end
  end
end

---@return nil
local function lazy_load_snippets()
  local snippets_path = vim.split(
    fn.globpath(fn.stdpath 'config' .. '/lua/snippets', '*.lua'),
    '\n'
  )
  -- Record filetypes of all opened buffers
  local opened_file_ftlist = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].ft
    if ft ~= '' then opened_file_ftlist[ft] = true end
  end
  local groupid = vim.api.nvim_create_augroup('LuaSnipLazyLoadSnippets', {})
  for _, path in ipairs(snippets_path) do
    local ft = fn.fnamemodify(path, ':t:r')
    -- Load snippet immediately if ft matches the filetype of any opened buffer
    if opened_file_ftlist[ft] then
      load_snippets(ft)
    else -- Otherwise, load snippet when filetype is detected
      vim.api.nvim_create_autocmd('FileType', {
        once = true,
        pattern = ft,
        group = groupid,
        callback = function()
          load_snippets(ft)
          return true
        end,
      })
    end
  end
end

---@return nil
local function set_keymaps()
  -- stylua: ignore start
  vim.keymap.set('s', '<Tab>',   function() ls.jump(1) end)
  vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end)
  vim.keymap.set('s', '<C-n>',   function() return ls.choice_active() and '<Plug>luasnip-next-choice' or '<C-n>' end, { expr = true })
  vim.keymap.set('s', '<C-p>',   function() return ls.choice_active() and '<Plug>luasnip-prev-choice' or '<C-p>' end, { expr = true })
  -- stylua: ignore end
end

ls.setup {
  keep_roots = true,
  link_roots = false,
  link_children = true,
  region_check_events = 'CursorMoved,CursorMovedI',
  delete_check_events = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
  ext_opts = {
    [ls_types.choiceNode] = {
      active = {
        virt_text = { { PREF.icons.kinds.Enum, 'Number' } },
      },
    },
    [ls_types.insertNode] = {
      unvisited = {
        virt_text = { { '│', 'NonText' } },
        virt_text_pos = 'inline',
      },
    },
    [ls_types.exitNode] = {
      unvisited = {
        virt_text = { { '│', 'NonText' } },
        virt_text_pos = 'inline',
      },
    },
  },
}

lazy_load_snippets()
set_keymaps()
