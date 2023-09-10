local cmp = require 'cmp'
local luasnip = require 'luasnip'
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup {
  view = { entries = 'custom' },
  window = {
    documentation = {
      max_width = 80,
      max_height = 20,
    },
  },
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
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
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
    { name = 'nvim_lsp' },
    { name = 'buffer', max_item_count = 8 },
    { name = 'path' },
    { name = 'calc' },
  },
  sorting = {
    ---@type table[]|function[]
    comparators = {
      cmp.config.compare.kind,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.score,
    },
  },
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  enabled = true,
  view = { entries = 'wildmenu' },
  sources = { { name = 'buffer' } },
})
cmp.setup.cmdline('?', {
  enabled = true,
  view = { entries = 'wildmenu' },
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
