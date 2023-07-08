local utils = require('utils')

---Check if there exists an LS that supports the given method
---for the given buffer
---@param method string the method to check for
---@param bufnr number buffer handler
local function supports_method(method, bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Setup LSP keymaps
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function setup_keymaps(_, bufnr)
  ---@param direction 'prev'|'next'
  ---@param level 'ERROR'|'WARN'|'INFO'|'HINT'
  ---@return function
  local function goto_diagnostic(direction, level)
    return function()
      vim.diagnostic['goto_' .. direction]({
        severity = vim.diagnostic.severity[level],
      })
    end
  end
  ---@param method string LSP method
  ---@param fn_name string function name, used to index vim.lsp.buf
  ---@param fallback string fallback keymap
  ---@return function
  local function if_supports(method, fn_name, fallback)
    return function()
      if supports_method(method, bufnr) then
        vim.lsp.buf[fn_name]()
        return '<Ignore>'
      else
        return fallback
      end
    end
  end
  -- stylua: ignore start
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action,   { buffer = bufnr })
  vim.keymap.set('n', '<Leader>r',  vim.lsp.buf.rename,        { buffer = bufnr })
  vim.keymap.set('n', '<Leader>R',  vim.lsp.buf.references,    { buffer = bufnr })
  vim.keymap.set('n', '<Leader>e',  vim.diagnostic.open_float, { buffer = bufnr })
  vim.keymap.set('n', '<leader>El', vim.diagnostic.setloclist, { buffer = bufnr })
  vim.keymap.set('n', '<leader>Eq', vim.diagnostic.setqflist,  { buffer = bufnr })
  vim.keymap.set('n', '[e',         vim.diagnostic.goto_prev,  { buffer = bufnr })
  vim.keymap.set('n', ']e',         vim.diagnostic.goto_next,  { buffer = bufnr })
  vim.keymap.set('n', 'gq;',        vim.lsp.buf.format,        { buffer = bufnr })
  vim.keymap.set('n', 'gq;',        vim.lsp.buf.format,        { buffer = bufnr })
  vim.keymap.set('n', '[E', goto_diagnostic('prev', 'ERROR'),  { buffer = bufnr })
  vim.keymap.set('n', ']E', goto_diagnostic('next', 'ERROR'),  { buffer = bufnr })
  vim.keymap.set('n', '[W', goto_diagnostic('prev', 'WARN'),   { buffer = bufnr })
  vim.keymap.set('n', '[W', goto_diagnostic('prev', 'WARN'),   { buffer = bufnr })
  vim.keymap.set('n', ']I', goto_diagnostic('next', 'INFO'),   { buffer = bufnr })
  vim.keymap.set('n', ']I', goto_diagnostic('next', 'INFO'),   { buffer = bufnr })
  vim.keymap.set('n', ']H', goto_diagnostic('next', 'HINT'),   { buffer = bufnr })
  vim.keymap.set('n', ']H', goto_diagnostic('next', 'HINT'),   { buffer = bufnr })
  vim.keymap.set('n', 'gd', if_supports('textDocument/definition', 'definition', 'gd'),          { buffer = bufnr, expr = true })
  vim.keymap.set('n', 'gD', if_supports('textDocument/typeDefinition', 'type_definition', 'gD'), { buffer = bufnr, expr = true })
  vim.keymap.set('n', 'K',  if_supports('textDocument/hover', 'hover', 'K'),                     { buffer = bufnr, expr = true })
  -- stylua: ignore end
end

---@class lsp_command_parsed_arg_t : parsed_arg_t
---@field apply boolean|nil
---@field async boolean|nil
---@field bufnr integer|nil
---@field context table|nil
---@field cursor_position table|nil
---@field defaults table|nil
---@field diagnostics table|nil
---@field disable boolean|nil
---@field enable boolean|nil
---@field filter function|nil
---@field float boolean|table|nil
---@field format function|nil
---@field formatting_options table|nil
---@field global boolean|nil
---@field groups table|nil
---@field header string|table|nil
---@field id integer|nil
---@field local boolean|nil
---@field name string|nil
---@field namespace integer|nil
---@field new_name string|nil
---@field open boolean|nil
---@field options table|nil
---@field opts table|nil
---@field pat string|nil
---@field prefix function|string|table|nil
---@field query table|nil
---@field range table|nil
---@field severity integer|nil
---@field severity_map table|nil
---@field severity_sort boolean|nil
---@field show-status boolean|nil
---@field source boolean|string|nil
---@field str string|nil
---@field suffix function|string|table|nil
---@field timeout_ms integer|nil
---@field title string|nil
---@field toggle boolean|nil
---@field win_id integer|nil
---@field winnr integer|nil
---@field wrap boolean|nil

---Parse arguments passed to LSP commands
---@param fargs string[] list of arguments
---@param fn_name_alt string|nil alternative function name
---@return string|nil fn_name corresponding LSP / diagnostic function name
---@return lsp_command_parsed_arg_t parsed the parsed arguments
local function parse_cmdline_args(fargs, fn_name_alt)
  local fn_name = fn_name_alt or fargs[1] and table.remove(fargs, 1) or nil
  local parsed = utils.command.parse_cmdline_args(fargs)
  return fn_name, parsed
end

---LSP command argument handler for functions that receive a range
---@param args lsp_command_parsed_arg_t
---@param tbl table information passed to the command
---@return table args
local function arg_handler_range(args, tbl)
  args.range = args.range
    or tbl.range > 0 and {
      ['start'] = { tbl.line1, 0 },
      ['end'] = { tbl.line2, 999 },
    }
    or nil
  return args
end

---Extract the first item from a table, expand it to absolute path if possible
---@param args lsp_command_parsed_arg_t
---@return any
local function arg_handler_item(args)
  for _, item in pairs(args) do
    return type(item) == 'string'
        and vim.uv.fs_stat(vim.fn.fnamemodify(item, ':p'))
        and vim.fn.resolve(vim.fn.fnamemodify(item, ':p'))
      or item
  end
end

---@type table<string, string[]|fun(): any[]>
local optvals = {
  bool = { 'v:true', 'v:false' },
  severity = { 'WARN', 'INFO', 'ERROR', 'HINT' },
  bufs = function()
    return vim.api.nvim_list_bufs()
  end,
}

---@class subcommand_info_t : table
---@field arg_handler function|nil
---@field params table|nil
---@field opts table|nil
---@field fn_override function|nil
---@field completion function|nil

local subcommands = {
  lsp = {
    ---LSP subcommands
    ---@type table<string, subcommand_info_t>
    buf = {
      references = {
        ---@param args lsp_command_parsed_arg_t
        arg_handler = function(args)
          return args.context, args.options
        end,
        opts = { 'context', 'options.on_list' },
      },
      rename = {
        ---@param args lsp_command_parsed_arg_t
        arg_handler = function(args)
          return args.new_name or args[1], args.options
        end,
        opts = {
          'new_name',
          'options.filter',
          'options.name',
        },
      },
      workspace_symbol = {
        ---@param args lsp_command_parsed_arg_t
        arg_handler = function(args)
          return args.query, args.options
        end,
        opts = { 'query', 'options.on_list' },
      },
      format = {
        arg_handler = arg_handler_range,
        opts = {
          'formatting_options',
          'formatting_options.tabSize',
          ['formatting_options.insertSpaces'] = optvals.bool,
          ['formatting_options.trimTrailingWhitespace'] = optvals.bool,
          ['formatting_options.insertFinalNewline'] = optvals.bool,
          ['formatting_options.trimFinalNewlines'] = optvals.bool,
          'timeout_ms',
          ['bufnr'] = optvals.bufs,
          'filter',
          ['async'] = optvals.bool,
          'id',
          'name',
          'range',
        },
      },
      auto_format = {
        ---@param args lsp_command_parsed_arg_t
        ---@param tbl table information passed to the command
        ---@return lsp_command_parsed_arg_t args
        ---@return table tbl
        arg_handler = function(args, tbl)
          args.format = arg_handler_range(args, tbl).format
          return args, tbl
        end,
        params = {
          'enable',
          'disable',
          'toggle',
          'reset',
          'status',
        },
        opts = {
          'format.formatting_options',
          'format.formatting_options.tabSize',
          ['format.formatting_options.insertSpaces'] = optvals.bool,
          ['format.formatting_options.trimTrailingWhitespace'] = optvals.bool,
          ['formatting_options.insertFinalNewline'] = optvals.bool,
          ['format.formatting_options.trimFinalNewlines'] = optvals.bool,
          'format.timeout_ms',
          ['format.bufnr'] = optvals.bufs,
          'format.filter',
          'format.async',
          'format.id',
          'format.name',
          'format.range',
          ['local'] = optvals.bool,
          ['global'] = optvals.bool,
        },
        ---@param args lsp_command_parsed_arg_t
        ---@param tbl table information passed to the command
        fn_override = function(args, tbl)
          ---@type bufopt_t
          local opt_autofmt_enabled =
            utils.classes.bufopt_t:new('lsp_autofmt_enabled', false)
          ---@type bufopt_t
          local opt_autofmt_opts = utils.classes.bufopt_t:new(
            'lsp_autofmt_opts',
            { timeout_ms = 500 }
          )
          if vim.fn.exists('#LspAutoFmt') == 0 then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('LspAutoFmt', {}),
              callback = function(info)
                if opt_autofmt_enabled:get(info.buf) then
                  vim.lsp.buf.format(opt_autofmt_opts:get(info.buf))
                end
              end,
              desc = 'LSP format on save.',
            })
          end
          if tbl.bang or vim.tbl_contains(args, 'toggle') then
            opt_autofmt_enabled:scope_action(args, 'toggle')
          elseif tbl.fargs[1] == '&' or vim.tbl_contains(args, 'reset') then
            opt_autofmt_enabled:scope_action(args, 'reset')
            opt_autofmt_opts:scope_action(args, 'reset')
          elseif tbl.fargs[1] == '?' or vim.tbl_contains(args, 'status') then
            opt_autofmt_enabled:scope_action(args, 'print')
            opt_autofmt_opts:scope_action(args, 'print')
          elseif vim.tbl_contains(args, 'enable') then
            opt_autofmt_enabled:scope_action(args, 'set', true)
          elseif vim.tbl_contains(args, 'disable') then
            opt_autofmt_enabled:scope_action(args, 'set', false)
          end
          if args.format then
            opt_autofmt_opts:scope_action(
              args,
              'set',
              vim.tbl_deep_extend(
                'force',
                opt_autofmt_opts:scope_action(args, 'get'),
                args.format
              )
            )
          end
        end,
      },
      code_action = {
        opts = {
          'context.diagnostics',
          'context.only',
          'context.triggerKind',
          'filter',
          ['apply'] = optvals.bool,
          'range',
        },
      },
      add_workspace_folder = {
        arg_handler = arg_handler_item,
        completion = function(arglead, _, _)
          local basedir = arglead == '' and vim.fn.getcwd() or arglead
          local incomplete = nil ---@type string|nil
          if not vim.uv.fs_stat(basedir) then
            basedir = vim.fn.fnamemodify(basedir, ':h')
            incomplete = vim.fn.fnamemodify(arglead, ':t')
          end
          local subdirs = {}
          for name, type in vim.fs.dir(basedir) do
            if type == 'directory' and name ~= '.' and name ~= '..' then
              table.insert(
                subdirs,
                vim.fn.fnamemodify(
                  vim.fn.resolve(basedir .. '/' .. name),
                  ':p:~:.'
                )
              )
            end
          end
          if incomplete then
            return vim.tbl_filter(function(s)
              return s:find(incomplete, 1, true)
            end, subdirs)
          end
          return subdirs
        end,
      },
      remove_workspace_folder = {
        arg_handler = arg_handler_item,
        completion = function(_, _, _)
          return vim.tbl_map(function(path)
            local short = vim.fn.fnamemodify(path, ':p:~:.')
            return short ~= '' and short or './'
          end, vim.lsp.buf.list_workspace_folders())
        end,
      },
      execute_command = { arg_handler = arg_handler_item },
      type_definition = {
        opts = {
          'reuse_win',
          ['on_list'] = optvals.bool,
        },
      },
      declaration = {
        opts = {
          'reuse_win',
          ['on_list'] = optvals.bool,
        },
      },
      definition = {
        opts = {
          'reuse_win',
          ['on_list'] = optvals.bool,
        },
      },
      document_symbol = {
        opts = {
          ['on_list'] = optvals.bool,
        },
      },
      implementation = {
        opts = {
          ['on_list'] = optvals.bool,
        },
      },
      hover = {},
      document_highlight = {},
      clear_references = {},
      list_workspace_folders = {
        fn_override = function()
          vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
      },
      incoming_calls = {},
      outgoing_calls = {},
      server_ready = {
        fn_override = function(...)
          vim.notify(vim.inspect(vim.lsp.buf.server_ready(...)))
        end,
      },
      signature_help = {},
    },
  },

  ---Diagnostic subcommands
  ---@type table<string, subcommand_info_t>
  diagnostic = {
    config = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.opts, args.namespace
      end,
      opts = {
        ['opts.underline'] = optvals.bool,
        ['opts.underline.severity'] = optvals.severity,
        ['opts.virtual_text'] = optvals.bool,
        ['opts.virtual_text.severity'] = optvals.severity,
        'opts.virtual_text.source',
        'opts.virtual_text.spacing',
        'opts.virtual_text.prefix',
        'opts.virtual_text.suffix',
        'opts.virtual_text.format',
        ['opts.signs'] = optvals.bool,
        ['opts.signs.severity'] = optvals.severity,
        'opts.signs.priority',
        'opts.float',
        ['opts.float.bufnr'] = optvals.bufs,
        'opts.float.namespace',
        'opts.float.scope',
        'opts.float.pos',
        'opts.float.severity_sort',
        ['opts.float.severity'] = optvals.severity,
        'opts.float.header',
        'opts.float.source',
        'opts.float.format',
        'opts.float.prefix',
        'opts.float.suffix',
        ['opts.update_in_insert'] = optvals.bool,
        'opts.severity_sort',
        ['opts.severity_sort.reverse'] = optvals.bool,
        'namespace',
      },
    },
    disable = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.namespace
      end,
      opts = {
        ['bufnr'] = optvals.bufs,
        'namespace',
      },
    },
    enable = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.namespace
      end,
      opts = {
        ['bufnr'] = optvals.bufs,
        'namespace',
      },
    },
    fromqflist = {
      arg_handler = arg_handler_item,
      opts = { 'list' },
      fn_override = function(...)
        vim.diagnostic.show(nil, 0, vim.diagnostic.fromqflist(...))
      end,
    },
    get = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.opts
      end,
      opts = {
        ['bufnr'] = optvals.bufs,
        'opts.namespace',
        'opts.lnum',
        ['opts.severity'] = optvals.severity,
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get(...)))
      end,
    },
    get_namespace = {
      arg_handler = arg_handler_item,
      opts = { 'namespace' },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_namespace(...)))
      end,
    },
    get_namespaces = {
      fn_override = function()
        vim.notify(vim.inspect(vim.diagnostic.get_namespaces()))
      end,
    },
    get_next = {
      opts = {
        'namespace',
        'cursor_position',
        'wrap',
        ['severity'] = optvals.severity,
        ['float'] = optvals.bool,
        ['float.bufnr'] = optvals.bufs,
        'float.namespace',
        'float.scope',
        'float.pos',
        'float.severity_sort',
        ['float.severity'] = optvals.severity,
        'float.header',
        'float.source',
        'float.format',
        'float.prefix',
        'float.suffix',
        'win_id',
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_next(...)))
      end,
    },
    get_next_pos = {
      opts = {
        'namespace',
        'cursor_position',
        'wrap',
        ['severity'] = optvals.severity,
        ['float'] = optvals.bool,
        ['float.bufnr'] = optvals.bufs,
        'float.namespace',
        'float.scope',
        'float.pos',
        'float.severity_sort',
        ['float.severity'] = optvals.severity,
        'float.header',
        'float.source',
        'float.format',
        'float.prefix',
        'float.suffix',
        'win_id',
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_next_pos(...)))
      end,
    },
    get_prev = {
      opts = {
        'namespace',
        'cursor_position',
        'wrap',
        ['severity'] = optvals.severity,
        ['float'] = optvals.bool,
        ['float.bufnr'] = optvals.bufs,
        'float.namespace',
        'float.scope',
        'float.pos',
        'float.severity_sort',
        ['float.severity'] = optvals.severity,
        'float.header',
        'float.source',
        'float.format',
        'float.prefix',
        'float.suffix',
        'win_id',
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_prev(...)))
      end,
    },
    get_prev_pos = {
      opts = {
        'namespace',
        'cursor_position',
        'wrap',
        ['severity'] = optvals.severity,
        ['float'] = optvals.bool,
        ['float.bufnr'] = optvals.bufs,
        'float.namespace',
        'float.scope',
        'float.pos',
        'float.severity_sort',
        ['float.severity'] = optvals.severity,
        'float.header',
        'float.source',
        'float.format',
        'float.prefix',
        'float.suffix',
        'win_id',
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_prev_pos(...)))
      end,
    },
    goto_next = {
      opts = {
        'namespace',
        'cursor_position',
        'wrap',
        ['severity'] = optvals.severity,
        ['float'] = optvals.bool,
        ['float.bufnr'] = optvals.bufs,
        'float.namespace',
        'float.scope',
        'float.pos',
        'float.severity_sort',
        ['float.severity'] = optvals.severity,
        'float.header',
        'float.source',
        'float.format',
        'float.prefix',
        'float.suffix',
        'win_id',
      },
    },
    goto_prev = {
      opts = {
        'namespace',
        'cursor_position',
        'wrap',
        ['severity'] = optvals.severity,
        ['float'] = optvals.bool,
        ['float.bufnr'] = optvals.bufs,
        'float.namespace',
        'float.scope',
        'float.pos',
        'float.severity_sort',
        ['float.severity'] = optvals.severity,
        'float.header',
        'float.source',
        'float.format',
        'float.prefix',
        'float.suffix',
        'win_id',
      },
    },
    hide = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr
      end,
      opts = {
        'namespace',
        ['bufnr'] = optvals.bufs,
      },
    },
    is_disabled = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.namespace
      end,
      opts = {
        'namespace',
        ['bufnr'] = optvals.bufs,
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.is_disabled(...)))
      end,
    },
    match = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.str,
          args.pat,
          args.groups,
          args.severity_map,
          args.defaults
      end,
      opts = {
        'str',
        'pat',
        'groups',
        'severity_map',
        'defaults',
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.match(...)))
      end,
    },
    open_float = {
      opts = {
        ['bufnr'] = optvals.bufs,
        'namespace',
        'scope',
        'pos',
        ['severity_sort'] = optvals.bool,
        ['severity'] = optvals.severity,
        'header',
        ['source'] = optvals.bool,
        'format',
        'prefix',
        'suffix',
      },
    },
    reset = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr
      end,
      opts = {
        'namespace',
        ['bufnr'] = optvals.bufs,
      },
    },
    set = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr, args.diagnostics, args.opts
      end,
      opts = {
        'namespace',
        ['bufnr'] = optvals.bufs,
        'diagnostics',
        ['opts.underline'] = optvals.bool,
        ['opts.underline.severity'] = optvals.severity,
        ['opts.virtual_text'] = optvals.bool,
        ['opts.virtual_text.severity'] = optvals.severity,
        'opts.virtual_text.source',
        'opts.virtual_text.spacing',
        'opts.virtual_text.prefix',
        'opts.virtual_text.suffix',
        'opts.virtual_text.format',
        ['opts.signs'] = optvals.bool,
        ['opts.signs.severity'] = optvals.severity,
        'opts.signs.priority',
        'opts.float',
        ['opts.float.bufnr'] = optvals.bufs,
        'opts.float.namespace',
        'opts.float.scope',
        'opts.float.pos',
        'opts.float.severity_sort',
        ['opts.float.severity'] = optvals.severity,
        'opts.float.header',
        'opts.float.source',
        'opts.float.format',
        'opts.float.prefix',
        'opts.float.suffix',
        ['opts.update_in_insert'] = optvals.bool,
        'opts.severity_sort',
        ['opts.severity_sort.reverse'] = optvals.bool,
      },
    },
    setloclist = {
      opts = {
        'namespace',
        'winnr',
        'open',
        'title',
        ['severity'] = optvals.severity,
      },
    },
    setqflist = {
      opts = {
        'namespace',
        'open',
        'title',
        ['severity'] = optvals.severity,
      },
    },
    show = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr, args.diagnostics, args.opts
      end,
      opts = {
        'namespace',
        ['bufnr'] = optvals.bufs,
        'diagnostics',
        ['opts.underline'] = optvals.bool,
        ['opts.underline.severity'] = optvals.severity,
        ['opts.virtual_text'] = optvals.bool,
        ['opts.virtual_text.severity'] = optvals.severity,
        'opts.virtual_text.source',
        'opts.virtual_text.spacing',
        'opts.virtual_text.prefix',
        'opts.virtual_text.suffix',
        'opts.virtual_text.format',
        ['opts.signs'] = optvals.bool,
        ['opts.signs.severity'] = optvals.severity,
        'opts.signs.priority',
        'opts.float',
        ['opts.float.bufnr'] = optvals.bufs,
        'opts.float.namespace',
        'opts.float.scope',
        'opts.float.pos',
        'opts.float.severity_sort',
        ['opts.float.severity'] = optvals.severity,
        'opts.float.header',
        'opts.float.source',
        'opts.float.format',
        'opts.float.prefix',
        'opts.float.suffix',
        ['opts.update_in_insert'] = optvals.bool,
        'opts.severity_sort',
        ['opts.severity_sort.reverse'] = optvals.bool,
      },
    },
    toqflist = {
      arg_handler = arg_handler_item,
      opts = { 'diagnostics' },
      fn_override = function(...)
        vim.fn.setqflist(vim.diagnostic.toqflist(...))
      end,
    },
  },
}

---Get meta command function
---@param subcommand_info_list subcommand_info_t[] subcommands information
---@param fn_scope table scope of corresponding functions for subcommands
---@param fn_name_alt string|nil name of the function to call given no subcommand
---@return function meta_command_fn
local function command_meta(subcommand_info_list, fn_scope, fn_name_alt)
  ---Meta command function, calls the appropriate subcommand with args
  ---@param tbl table information passed to the command
  return function(tbl)
    local fn_name, cmdline_args = parse_cmdline_args(tbl.fargs, fn_name_alt)
    if not fn_name then
      return
    end
    local fn = subcommand_info_list[fn_name]
        and subcommand_info_list[fn_name].fn_override
      or fn_scope[fn_name]
    if not fn then
      return
    end
    local arg_handler = subcommand_info_list[fn_name].arg_handler
      or function(args)
        return args
      end
    fn(arg_handler(cmdline_args, tbl))
  end
end

---Get command completion function
---@param meta string meta command name
---@param subcommand_info_list subcommand_info_t[] subcommands information
---@return function completion_fn
local function command_complete(meta, subcommand_info_list)
  ---Command completion function
  ---@param arglead string leading portion of the argument being completed
  ---@param cmdline string entire command line
  ---@param cursorpos number cursor position in it (byte index)
  ---@return string[] completion completion results
  return function(arglead, cmdline, cursorpos)
    -- If subcommand is not specified, complete with subcommands
    if cmdline:sub(1, cursorpos):match('^%A*' .. meta .. '%s+%S*$') then
      return vim.tbl_filter(function(cmd)
        return cmd:find(arglead, 1, true) == 1
      end, vim.tbl_keys(subcommand_info_list))
    end
    -- If subcommand is specified, complete with its options or params
    local subcommand = utils.string.camel_to_snake(
      cmdline:match('^%s*' .. meta .. '(%w+)')
    ) or cmdline:match('^%s*' .. meta .. '%s+(%S+)')
    if not subcommand_info_list[subcommand] then
      return {}
    end
    -- Use subcommand's completion function if it exists
    if subcommand_info_list[subcommand].completion then
      return subcommand_info_list[subcommand].completion(
        arglead,
        cmdline,
        cursorpos
      )
    end
    -- Complete with subcommand's options or params
    local subcommand_info = subcommand_info_list[subcommand]
    if subcommand_info then
      return utils.command.complete(
        subcommand_info.params,
        subcommand_info.opts
      )(arglead, cmdline, cursorpos)
    end
    return {}
  end
end

---Setup commands
---@param _ table LS client, ignored
---@param bufnr number buffer handler
---@param meta string meta command name
---@param subcommand_info_list table<string, subcommand_info_t> subcommands information
---@param fn_scope table scope of corresponding functions for subcommands
local function setup_commands(_, bufnr, meta, subcommand_info_list, fn_scope)
  -- Format: MetaCommand sub_command opts ...
  vim.api.nvim_buf_create_user_command(
    bufnr,
    meta,
    command_meta(subcommand_info_list, fn_scope),
    {
      bang = true,
      range = true,
      nargs = '*',
      complete = command_complete(meta, subcommand_info_list),
    }
  )
  -- Format: MetaCommandSubcommand opts ...
  for subcommand, _ in pairs(subcommand_info_list) do
    vim.api.nvim_buf_create_user_command(
      bufnr,
      meta .. utils.string.snake_to_camel(subcommand),
      command_meta(subcommand_info_list, fn_scope, subcommand, subcommand),
      {
        bang = true,
        range = true,
        nargs = '*',
        complete = command_complete(meta, subcommand_info_list),
      }
    )
  end
end

---Automatically enable / disable diagnostics on mode change
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function setup_diagnostics_on_mode_change(_, bufnr)
  local augroup_diagnostic = 'LspDiagnostic' .. bufnr
  vim.api.nvim_create_augroup(augroup_diagnostic, { clear = true })
  vim.api.nvim_create_autocmd('ModeChanged', {
    buffer = bufnr,
    group = augroup_diagnostic,
    callback = function(tbl)
      if vim.fn.match(tbl.match, '.*:[iRsS\x13].*') ~= -1 then
        vim.diagnostic.disable(bufnr)
        vim.b._lsp_diagnostics_temp_disabled = true
      elseif not vim.wo.diff and vim.b._lsp_diagnostics_temp_disabled then
        vim.diagnostic.enable(bufnr)
        vim.b._lsp_diagnostics_temp_disabled = nil
      end
    end,
    desc = 'LSP diagnostics on mode change.',
  })
end

---Set up keymaps and commands
---@param client table LS client, ignored
---@param bufnr number buffer handler
local function on_attach(client, bufnr)
  if not vim.b[bufnr].lsp_attached then
    vim.b[bufnr].lsp_attached = true
    setup_keymaps(client, bufnr)
    setup_commands(client, bufnr, 'Lsp', subcommands.lsp.buf, vim.lsp.buf)
    setup_commands(
      client,
      bufnr,
      'Diagnostic',
      subcommands.diagnostic,
      vim.diagnostic
    )
    setup_diagnostics_on_mode_change(client, bufnr)
  end
end

-- Merge default capabilities with extra capabilities provided by cmp-nvim-lsp
local capabilities =
  vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
          deprecatedSupport = true,
          preselectSupport = true,
          tagSupport = {
            valueSet = {
              1, -- Deprecated
            },
          },
          insertReplaceSupport = true,
          resolveSupport = {
            properties = {
              'documentation',
              'detail',
              'additionalTextEdits',
            },
          },
          insertTextModeSupport = {
            valueSet = {
              1, -- asIs
              2, -- adjustIndentation
            },
          },
          labelDetailsSupport = true,
        },
        contextSupport = true,
        insertTextMode = 1,
        completionList = {
          itemDefaults = {
            'commitCharacters',
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          },
        },
      },
    },
  })

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

return default_config
