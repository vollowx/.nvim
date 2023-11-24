local cmp = require 'cmp'
local luasnip = require 'luasnip'
local icons = require('utils.static').icons

local icon_dot = vim.trim(icons.ui.CircleSmall)
local icon_calc = icons.kinds.Calculator
local icon_folder = icons.kinds.Folder
local icon_file = icons.kinds.File
local compltype_path = {
  dir = true,
  file = true,
  file_in_path = true,
  runtime = true,
}

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
      local compltype = vim.fn.getcmdcompltype()
      local complpath = compltype_path[compltype]
      -- Fix cmp path completion not escaping special characters
      -- (e.g. `#`, spaces) in cmdline,
      if complpath then
        local path_escaped = vim.fn.fnameescape(cmp_item.word)
        cmp_item.word = path_escaped
        cmp_item.abbr = path_escaped
      end
      -- Use special icons for file / directory completions
      if cmp_item.kind == 'File' or cmp_item.kind == 'Folder' or complpath then
        if cmp_item.word:match '/$' then -- Directories
          cmp_item.kind = icon_folder
          cmp_item.kind_hl_group = 'CmpItemKindFolder'
        else -- Files
          local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
          if devicons_ok then
            local icon, icon_hl = devicons.get_icon(
              vim.fs.basename(cmp_item.word),
              vim.fn.fnamemodify(cmp_item.word, ':e'),
              { default = true }
            )
            cmp_item.kind = icon and icon .. ' ' or icon_file
            cmp_item.kind_hl_group = icon_hl or 'CmpItemKindFile'
          end
        end
      else -- Use special icons for cmdline / calc completions
        ---@type table<string, string> override icons with `entry.source.name`
        local icon_override = {
          cmdline = icon_dot,
          calc = icon_calc,
        }
        cmp_item.kind = icon_override[entry.source.name]
          or icons[cmp_item.kind]
          or ''
      end
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
    ['<S-Tab>'] = {
      ['c'] = function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.complete()
        end
      end,
      ['i'] = function(fallback)
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
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
        if luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
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
    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      { 'i', 'c' }
    ),
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'calc' },
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
