local cmp = require 'cmp'
local luasnip = require 'luasnip'
local borders = require('utils.static').borders
local icons = require('utils.static').icons
local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

local border = require('core.settings').border

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
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, cmp_item)
      ---@type table<string, string> override icons with `entry.source.name`
      local icon_override = {
        cmdline = icons.Terminal,
        calc = icons.Calculator,
      }
      cmp_item.kind = icon_override[entry.source.name] or icons[cmp_item.kind]
      ---@param field string
      ---@param min_width integer
      ---@param max_width integer
      ---@return nil
      local function clamp(field, min_width, max_width)
        if not cmp_item[field] or not type(cmp_item) == 'string' then return end
        -- In case that min_width > max_width
        if min_width > max_width then
          min_width, max_width = max_width, min_width
        end
        local field_str = cmp_item[field]
        local field_width = vim.fn.strdisplaywidth(field_str)
        if field_width > max_width then
          local former_width = math.floor(max_width * 0.6)
          local latter_width = math.max(0, max_width - former_width - 1)
          cmp_item[field] = string.format('%s…%s', field_str:sub(1, former_width), field_str:sub(-latter_width))
        elseif field_width < min_width then
          cmp_item[field] = string.format('%-' .. min_width .. 's', field_str)
        end
      end
      clamp('abbr', vim.go.pumwidth, 32)
      clamp('menu', 0, 16)
      return cmp_item
    end,
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
  -- cmp floating window config
  window = {
    completion = {
      border = borders[border .. '_clc'],
      winhighlight = 'Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel',
    },
    documentation = {
      border = borders[border .. '_clc'],
      winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder',
    },
  },
  performance = {
    async_budget = 1,
    max_view_entries = 120,
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
