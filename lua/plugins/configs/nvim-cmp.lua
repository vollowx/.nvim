local cmp = require 'cmp'
local luasnip = require 'luasnip'
local icons = require('utils.static').icons
local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

---Filter out unwanted entries
---@param entry cmp.Entry
---@param _ cmp.Context ignored
---@return boolean
local function entry_filter(entry, _)
  return not vim.tbl_contains({
    'No matches found',
    'Searching...',
    'Workspace loading',
  }, entry.completion_item.label)
end

cmp.setup {
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    format = function(entry, cmp_item)
      ---@type table<string, string> override icons with `entry.source.name`
      local icon_override = {
        cmdline = icons.Command,
        calc = icons.Calculator,
      }
      cmp_item.kind = (icon_override[entry.source.name] or icons[cmp_item.kind]) .. ' ' .. cmp_item.kind
      return cmp_item
    end,
  },
  -- Scrollbar provided by nvim-scrollview
  window = {
    completion = {
      border = 'solid',
      col_offset = -1,
    },
    documentation = {
      border = 'solid',
    },
  },
  performance = {
    async_budget = 1,
    max_view_entries = 120,
  },
  experimental = { ghost_text = { hl_group = 'Whitespace' } },
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm {
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ['<S-Tab>'] = {
      ['c'] = function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.complete()
        end
      end,
      ['i'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require('luasnip').jumpable(-1) then
          vim.fn.feedkeys(t '<Plug>luasnip-jump-prev', '')
        else
          fallback()
        end
      end,
    },
    ['<Tab>'] = {
      ['c'] = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end,
      ['i'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require('luasnip').expand_or_locally_jumpable() then
          vim.fn.feedkeys(t '<Plug>luasnip-expand-or-jump')
        else
          fallback()
        end
      end,
    },
    ['<C-p>'] = {
      ['c'] = cmp.mapping.select_prev_item(),
      ['i'] = function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          cmp.complete()
        end
      end,
    },
    ['<C-n>'] = {
      ['c'] = cmp.mapping.select_next_item(),
      ['i'] = function()
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          cmp.complete()
        end
      end,
    },
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-w>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { 'i', 'c' }),
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    {
      name = 'nvim_lsp',
      max_item_count = 350,
      entry_filter = entry_filter,
    },
    { name = 'buffer' },
    { name = 'spell' },
    { name = 'path' },
    { name = 'calc' },
  },
  sorting = {
    ---@type table[]|function[]
    comparators = {
      cmp.config.compare.kind,
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.exact,
      cmp.config.compare.score,
    },
  },
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  enabled = true,
  sources = { { name = 'buffer' } },
})
cmp.setup.cmdline('?', {
  enabled = true,
  sources = { { name = 'buffer' } },
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  enabled = true,
  sources = {
    { name = 'path', group_index = 1 },
    { name = 'cmdline', group_index = 2 },
  },
})
-- Complete vim.ui.input()
cmp.setup.cmdline('@', {
  enabled = true,
  sources = {
    { name = 'path', group_index = 1 },
    { name = 'cmdline', group_index = 2 },
    { name = 'buffer', group_index = 3 },
  },
})

-- Completion in DAP buffers
cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
  enabled = true,
  sources = {
    { name = 'dap' },
  },
})
