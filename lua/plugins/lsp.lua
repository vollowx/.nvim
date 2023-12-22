local icons = require('utils.static').icons
local horiz = vim.opt.fillchars:get().horiz

return {
  {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    config = function()
      ---Customize LspInfo floating window
      require('lspconfig.ui.windows').default_options.border = 'shadow'
      vim.api.nvim_create_autocmd('VimResized', {
        desc = 'Reload LspInfo floating window on VimResized.',
        group = vim.api.nvim_create_augroup('LspInfoResize', {}),
        callback = function()
          if vim.bo.ft == 'lspinfo' then
            vim.api.nvim_win_close(0, true)
            vim.cmd 'LspInfo'
          end
        end,
      })

      local manager = require 'lspconfig.manager'
      ---@diagnostic disable-next-line: invisible
      local _start_new_client = manager._start_new_client
      ---Override lspconfig manager `_start_new_client()` method to silently
      ---quit if language server is not installed
      ---@param _ integer bufnr, ignored
      ---@param new_config lspconfig.Config
      ---@vararg any
      ---@diagnostic disable-next-line: duplicate-set-field, invisible
      function manager:_start_new_client(_, new_config, ...)
        local bin = new_config and new_config.cmd and new_config.cmd[1]
        if bin and vim.fn.executable(bin) == 0 then return end
        return _start_new_client(self, _, new_config, ...)
      end

      ---Setup all LSP servers
      local lspconfig = require 'lspconfig'
      local ft_servers = require('utils.static').langs:map 'lsp_server'
      local server_configs = require 'configs.lsp-server-configs'
      ---@param ft string file type
      ---@return boolean? is_setup
      local function setup_ft(ft)
        local servers = ft_servers[ft]
        if not servers then return false end
        if type(servers) ~= 'table' then servers = { servers } end
        for _, server in ipairs(servers) do
          lspconfig[server].setup(server_configs[server])
        end
        ft_servers[ft] = nil
        vim.api.nvim_exec_autocmds('FileType', { pattern = ft })
        return true
      end
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        setup_ft(vim.bo[buf].ft)
      end
      local groupid = vim.api.nvim_create_augroup('LspServerLazySetup', {})
      for ft, _ in pairs(ft_servers) do
        vim.api.nvim_create_autocmd('FileType', {
          once = true,
          pattern = ft,
          group = groupid,
          callback = function() return setup_ft(ft) end,
        })
      end

      ---Check if there exists an LS that supports the given method
      ---for the given buffer
      ---@param method string the method to check for
      ---@param bufnr number buffer handler
      local function supports_method(method, bufnr)
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        for _, client in ipairs(clients) do
          if client.supports_method(method) then return true end
        end
        return false
      end

      ---Setup LSP keymaps
      ---@return nil
      local function setup_keymaps()
        ---@param direction 'prev'|'next'
        ---@param level 'ERROR'|'WARN'|'INFO'|'HINT'
        ---@return function
        local function goto_diagnostic(direction, level)
          return function()
            vim.diagnostic['goto_' .. direction] {
              severity = vim.diagnostic.severity[level],
            }
          end
        end
        ---@param method string LSP method
        ---@param fn_name string function name, used to index vim.lsp.buf
        ---@param fallback string fallback keymap
        ---@return function
        local function if_supports_lsp_method(method, fn_name, fallback)
          return function()
            return supports_method(method, 0)
                and string.format(
                  '<Cmd>lua vim.lsp.buf["%s"]()<CR>',
                  vim.fn.escape(fn_name, '"\\')
                )
              or fallback
          end
        end
      -- stylua: ignore start
      -- vim.keymap.set({ 'n' }, 'gq;', vim.lsp.buf.format)
      vim.keymap.set({ 'n', 'x' }, '<Leader>ca', vim.lsp.buf.code_action)
      vim.keymap.set({ 'n', 'x' }, '<Leader>r', vim.lsp.buf.rename)
      vim.keymap.set({ 'n', 'x' }, '<Leader>e', vim.diagnostic.open_float)
      vim.keymap.set({ 'n', 'x' }, '<leader>E', vim.diagnostic.setloclist)
      vim.keymap.set({ 'n', 'x' }, '[e', vim.diagnostic.goto_prev)
      vim.keymap.set({ 'n', 'x' }, ']e', vim.diagnostic.goto_next)
      vim.keymap.set({ 'n', 'x' }, '[E', goto_diagnostic('prev', 'ERROR'))
      vim.keymap.set({ 'n', 'x' }, ']E', goto_diagnostic('next', 'ERROR'))
      vim.keymap.set({ 'n', 'x' }, '[W', goto_diagnostic('prev', 'WARN'))
      vim.keymap.set({ 'n', 'x' }, ']W', goto_diagnostic('next', 'WARN'))
      vim.keymap.set({ 'n', 'x' }, '[I', goto_diagnostic('prev', 'INFO'))
      vim.keymap.set({ 'n', 'x' }, ']I', goto_diagnostic('next', 'INFO'))
      vim.keymap.set({ 'n', 'x' }, '[H', goto_diagnostic('prev', 'HINT'))
      vim.keymap.set({ 'n', 'x' }, ']H', goto_diagnostic('next', 'HINT'))
      vim.keymap.set({ 'n', 'x' }, 'g.', vim.lsp.buf.references)
      vim.keymap.set({ 'n', 'x' }, 'gd', if_supports_lsp_method('textDocument/definition', 'definition', 'gd'),
        { expr = true })
      vim.keymap.set({ 'n', 'x' }, 'gD', if_supports_lsp_method('textDocument/typeDefinition', 'type_definition', 'gD'),
        { expr = true })
        -- stylua: ignore end
      end

      -- Configure diagnostics style
      vim.lsp.handlers['textDocument/publishDiagnostics'] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = true,
          virtual_text = false,
          update_in_insert = true,
          severity_sort = true,
        })

      local lsp_autostop_pending
      ---Automatically stop LSP servers that no longer attaches to any buffers
      ---
      ---  Once `BufDelete` is triggered, wait for 60s before checking and
      ---  stopping servers, in this way the callback will be invoked once
      ---  every 60 seconds at most and can stop multiple clients at once
      ---  if possible, which is more efficient than checking and stopping
      ---  clients on every `BufDelete` events
      ---
      ---@return nil
      local function setup_lsp_autostop()
        vim.api.nvim_create_autocmd('BufDelete', {
          group = vim.api.nvim_create_augroup('LspAutoStop', {}),
          desc = 'Automatically stop idle language servers.',
          callback = function()
            if lsp_autostop_pending then return end
            lsp_autostop_pending = true
            vim.defer_fn(function()
              lsp_autostop_pending = nil
              for _, client in ipairs(vim.lsp.get_clients()) do
                if
                  vim.tbl_isempty(vim.lsp.get_buffers_by_client_id(client.id))
                then
                  vim.lsp.stop_client(client.id, true)
                end
              end
            end, 60000)
          end,
        })
      end

      ---Set up diagnostic signs
      ---@return nil
      local function setup_diagnostic_signs()
        for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
          local sign_name = 'DiagnosticSign' .. severity
          vim.fn.sign_define(sign_name, {
            text = icons.diagnostics[sign_name],
            texthl = sign_name,
            numhl = sign_name,
          })
        end
      end

      ---Set up LSP and diagnostic
      ---@return nil
      local function setup()
        setup_keymaps()
        setup_lsp_autostop()
        setup_diagnostic_signs()
      end

      setup()
    end,
    cmd = { 'LspInfo', 'LspStart' },
    keys = {
      { '<Leader>li', '<Cmd>LspInfo<CR>', desc = 'lsp: Server information' },
      { '<Leader>lr', '<Cmd>LspRestart<CR>', desc = 'lsp: Restart server' },
      { '<Leader>ls', '<Cmd>LspStart<CR>', desc = 'lsp: Start server' },
      { '<Leader>lp', '<Cmd>LspStop<CR>', desc = 'lsp: Stop server' },
    },
  },

  {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    opts = { scope = 'line' },
  },

  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    opts = function()
      local actions = require('glance').actions
      return {
        folds = {
          fold_closed = icons.ui.AngleRight,
          fold_open = icons.ui.AngleDown,
        },
        border = {
          enable = true,
          top_char = horiz,
          bottom_char = horiz,
        },
        theme = { mode = 'darken' },
        hooks = {
          before_open = function(results, open, _, method)
            if #results == 0 then
              vim.notify '[glance] this method is not supported by any of the servers registered for the current buffer'
            elseif #results == 1 and method == 'references' then
              vim.notify '[glance] the identifier under cursor is the only one found'
            else
              open(results)
            end
          end,
        },
        mappings = {
          ---@type table<string, function|boolean>
          list = {
            ['<C-n>'] = actions.next_location,
            ['<C-p>'] = actions.previous_location,
            ['sh'] = actions.enter_win 'preview',
            ['sv'] = actions.jump_vsplit,
            ['ss'] = actions.jump_split,
            ['s+'] = actions.jump_tab,

            ['Q'] = false,
            ['<Tab>'] = false,
            ['<S-Tab>'] = false,
            ['<Leader>l'] = false,
            ['v'] = false,
            ['s'] = false,
            ['t'] = false,
          },
          ---@type table<string, function|boolean>
          preview = {
            ['q'] = actions.close,
            ['<C-n>'] = actions.next_location,
            ['<C-p>'] = actions.previous_location,
            ['sl'] = actions.enter_win 'list',

            ['Q'] = false,
            ['<Tab>'] = false,
            ['<S-Tab>'] = false,
            ['<Leader>l'] = false,
          },
        },
      }
    end,
    keys = {
      { 'gd', '<Cmd>Glance definitions<CR>', desc = 'lsp: Peek definitions' },
      {
        'gD',
        '<Cmd>Glance type_definitions<CR>',
        desc = 'lsp: Peek type definitions',
      },
      { 'gr', '<Cmd>Glance references<CR>', desc = 'lsp: Peek references' },
      {
        'gi',
        '<Cmd>Glance implementations<CR>',
        desc = 'lsp: Peek implementations',
      },
    },
  },
}
