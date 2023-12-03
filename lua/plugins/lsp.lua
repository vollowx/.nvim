local icons = require('utils.static').icons
local horiz = vim.opt.fillchars:get().horiz

return {
  {
    'neovim/nvim-lspconfig',
    config = function() require 'configs.nvim-lspconfig' end,
    init = function()
      for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
        local sign_name = 'DiagnosticSign' .. severity
        vim.fn.sign_define(sign_name, {
          text = icons.diagnostics[sign_name],
          texthl = sign_name,
          numhl = sign_name,
          culhl = sign_name .. 'Cul',
        })
      end
    end,
    event = 'LazyFile',
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
    opts = {
      padding_top = 3,
      scope = 'line',
    },
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
          enable = false,
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
      { 'gD', '<Cmd>Glance definitions<CR>', desc = 'lsp: Peek definitions' },
      {
        'gT',
        '<Cmd>Glance type_definitions<CR>',
        desc = 'lsp: Peek type definitions',
      },
      { 'gR', '<Cmd>Glance references<CR>', desc = 'lsp: Peek references' },
      {
        'gI',
        '<Cmd>Glance implementations<CR>',
        desc = 'lsp: Peek implementations',
      },
    },
  },
}
