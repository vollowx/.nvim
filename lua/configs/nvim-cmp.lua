local cmp = require 'cmp'
local luasnip = require 'luasnip'
local icons = require('utils.static').icons

cmp.setup {
  view = { entries = 'custom' },
  window = {
    documentation = {
      max_width = 80,
      max_height = 20,
    },
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, cmp_item)
      cmp_item.kind = icons.kinds[cmp_item.kind] or ''
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
          cmp_item[field] = string.format(
            '%s…%s',
            field_str:sub(1, former_width),
            field_str:sub(-latter_width)
          )
        elseif field_width < min_width then
          cmp_item[field] = string.format('%-' .. min_width .. 's', field_str)
        end
      end
      clamp('abbr', vim.go.pw, math.max(60, math.ceil(vim.o.columns * 0.4)))
      clamp('menu', 0, math.max(16, math.ceil(vim.o.columns * 0.2)))
      return cmp_item
    end,
  },
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
  mapping = {
    ['<S-Tab>'] = function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
    ['<Tab>'] = function(fallback)
      if luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end,
    ['<C-p>'] = function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.choice_active() then
        luasnip.change_choice(-1)
      else
        cmp.complete()
      end
    end,
    ['<C-n>'] = function()
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        cmp.complete()
      end
    end,
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end,
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
}
