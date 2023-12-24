return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',

      'hrsh7th/cmp-cmdline',
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

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

      local icon_dot = PREF.icons.ui.Circle
      local icon_folder = PREF.icons.kinds.Folder
      local icon_file = PREF.icons.kinds.File
      local compltype_path = {
        dir = true,
        file = true,
        file_in_path = true,
        runtime = true,
      }

      ---@return integer[] buffer numbers
      local function source_buf_get_bufnrs()
        return vim.b.large_file and {} or { vim.api.nvim_get_current_buf() }
      end

      cmp.setup {
        window = {
          documentation = {
            max_width = 80,
            max_height = 20,
          },
        },
        performance = { max_view_entries = 64 },
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
            if
              cmp_item.kind == 'File'
              or cmp_item.kind == 'Folder'
              or complpath
            then
              if cmp_item.word:match '/$' then -- Directories
                cmp_item.kind = icon_folder
                cmp_item.kind_hl_group = 'CmpItemKindFolder'
              else -- Files
                local icon = icon_file
                local icon_hl = 'CmpItemKindFile'
                local devicons_ok, devicons =
                  pcall(require, 'nvim-web-devicons')
                if devicons_ok then
                  local icon, icon_hl = devicons.get_icon(
                    vim.fs.basename(cmp_item.word),
                    vim.fn.fnamemodify(cmp_item.word, ':e'),
                    { default = true }
                  )
                  icon = icon and icon .. ' '
                end
                cmp_item.kind = icon or icon_file
                cmp_item.kind_hl_group = icon_hl or 'CmpItemKindFile'
              end
            else -- Use special icons for cmdline completions
              ---@type table<string, string> override icons with `entry.source.name`
              local icon_override = {
                cmdline = icon_dot,
              }
              cmp_item.kind = icon_override[entry.source.name]
                or PREF.icons.kinds[cmp_item.kind]
                or ''
            end
            ---@param field string
            ---@param min_width integer
            ---@param max_width integer
            ---@return nil
            local function clamp(field, min_width, max_width)
              if not cmp_item[field] or not type(cmp_item) == 'string' then
                return
              end
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
                cmp_item[field] =
                  string.format('%-' .. min_width .. 's', field_str)
              end
            end
            clamp(
              'abbr',
              vim.go.pw,
              math.max(60, math.ceil(vim.o.columns * 0.4))
            )
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
          ['<Down>'] = cmp.mapping(
            cmp.mapping.select_next_item(),
            { 'i', 'c' }
          ),
          ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
          ['<PageDown>'] = cmp.mapping(
            cmp.mapping.select_next_item {
              count = vim.o.pumheight ~= 0 and math.ceil(vim.o.pumheight / 2)
                or 8,
            },
            { 'i', 'c' }
          ),
          ['<PageUp>'] = cmp.mapping(
            cmp.mapping.select_prev_item {
              count = vim.o.pumheight ~= 0 and math.ceil(vim.o.pumheight / 2)
                or 8,
            },
            { 'i', 'c' }
          ),
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
          { name = 'luasnip', max_item_count = 3 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'copilot' },
          {
            name = 'nvim_lsp',
            max_item_count = 20,
            entry_filter = entry_filter,
          },
          {
            name = 'buffer',
            max_item_count = 8,
            option = { get_bufnrs = source_buf_get_bufnrs },
          },
          { name = 'path' },
        },
      }

      cmp.setup.cmdline('/', {
        enabled = true,
        sources = {
          {
            name = 'buffer',
            option = { get_bufnrs = source_buf_get_bufnrs },
          },
        },
      })
      cmp.setup.cmdline('?', {
        enabled = true,
        sources = {
          {
            name = 'buffer',
            option = { get_bufnrs = source_buf_get_bufnrs },
          },
        },
      })
      cmp.setup.cmdline(':', {
        enabled = true,
        sources = {
          { name = 'path', group_index = 1 },
          {
            name = 'cmdline',
            option = { ignore_cmds = {} },
            group_index = 2,
          },
        },
      })
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      {
        'rafamadriz/friendly-snippets',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
      },
    },
    config = function()
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
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    opts = {
      panel = { auto_refresh = true },
      suggestion = { auto_trigger = true },
    },
  },
}
