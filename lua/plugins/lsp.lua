local horiz = vim.opt.fillchars:get().horiz

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPost',
    config = function()
      ---Customize LspInfo floating window
      require('lspconfig.ui.windows').default_options.border = PREF.ui.border
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

      ---Setup all LSP servers
      local lspconfig = require 'lspconfig'
      local servers = PREF.lsp_servers
      local server_configs = require 'plugins._lsp'
      for _, server in ipairs(servers) do
        lspconfig[server].setup(server_configs[server])
      end

      local map = vim.keymap.set

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

      -- map({ 'n' }, 'gq;', vim.lsp.buf.format)
      map({ 'n', 'x' }, '<Leader>ca', vim.lsp.buf.code_action)
      map({ 'n', 'x' }, '<Leader>r', vim.lsp.buf.rename)
      map({ 'n', 'x' }, '<Leader>e', vim.diagnostic.open_float)
      map({ 'n', 'x' }, '<leader>E', vim.diagnostic.setloclist)
      map({ 'n', 'x' }, '[e', vim.diagnostic.goto_prev)
      map({ 'n', 'x' }, ']e', vim.diagnostic.goto_next)
      map({ 'n', 'x' }, '[E', goto_diagnostic('prev', 'ERROR'))
      map({ 'n', 'x' }, ']E', goto_diagnostic('next', 'ERROR'))
      map({ 'n', 'x' }, '[W', goto_diagnostic('prev', 'WARN'))
      map({ 'n', 'x' }, ']W', goto_diagnostic('next', 'WARN'))
      map({ 'n', 'x' }, '[I', goto_diagnostic('prev', 'INFO'))
      map({ 'n', 'x' }, ']I', goto_diagnostic('next', 'INFO'))
      map({ 'n', 'x' }, '[H', goto_diagnostic('prev', 'HINT'))
      map({ 'n', 'x' }, ']H', goto_diagnostic('next', 'HINT'))

      -- Configure diagnostics style
      vim.lsp.handlers['textDocument/publishDiagnostics'] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = true,
          virtual_text = false,
          update_in_insert = true,
          severity_sort = true,
        })

      for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
        local sign_name = 'DiagnosticSign' .. severity
        vim.fn.sign_define(sign_name, {
          text = PREF.icons.diagnostics[severity],
          texthl = sign_name,
          numhl = sign_name,
        })
      end
    end,
    cmd = { 'LspInfo', 'LspStart' },
    keys = {
      { '<Leader>li', '<Cmd>LspInfo<CR>' },
      { '<Leader>lr', '<Cmd>LspRestart<CR>' },
      { '<Leader>ls', '<Cmd>LspStart<CR>' },
      { '<Leader>lp', '<Cmd>LspStop<CR>' },
    },
  },

  {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    opts = {
      enable = function() return vim.bo.filetype ~= 'lazy' end,
      scope = 'line',
    },
  },

  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = { vt_position = 'end_of_line' },
  },

  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    opts = function()
      local actions = require('glance').actions
      return {
        folds = {
          fold_closed = PREF.icons.ui.AngleRight,
          fold_open = PREF.icons.ui.AngleDown,
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
      { 'gd', '<Cmd>Glance definitions<CR>' },
      { 'gD', '<Cmd>Glance type_definitions<CR>' },
      { 'gr', '<Cmd>Glance references<CR>' },
      { 'gi', '<Cmd>Glance implementations<CR>' },
    },
  },
}
