local telescope = require 'telescope'
local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local static = require 'utils.static'

local border = require('core.settings').border

---Record buffers whose LSP clients are ready for 'textDocument/documentSymbol'
---requests
---@type table<integer, boolean>
local buf_client_ready = {}

vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('TelescopeClearBufClientCache', {}),
  callback = function(info) buf_client_ready[info.buf] = nil end,
  desc = 'Clear buf_client_ready cache on LspDetach.',
})

---Override builtin.lsp_document_symbols, builtin.lsp_workspace_symbols, and
---builtin.lsp_dynamic_workspace_symbols to fallback to use treesitter picker
---if the language server is not ready
---@param name string
---@param lsp_method string
local function override_lsp_picker(name, lsp_method)
  local orig_picker = builtin[name]
  builtin[name] = function(...)
    local buf = vim.api.nvim_get_current_buf()
    if buf_client_ready[buf] then
      orig_picker(...)
      return
    end
    local client = vim.tbl_filter(
      function(client) return client.supports_method(lsp_method) end,
      vim.lsp.get_active_clients {
        bufnr = buf,
      }
    )[1]
    if not client then
      builtin.treesitter(...)
      return
    end
    local client_ok = client.request_sync(lsp_method, {
      textDocument = vim.lsp.util.make_text_document_params(buf),
    }, 32, buf)
    if client_ok then
      buf_client_ready[buf] = true
      orig_picker(...)
    else
      builtin.treesitter(...)
    end
  end
end

override_lsp_picker('lsp_document_symbols', 'textDocument/documentSymbol')
override_lsp_picker('lsp_workspace_symbols', 'workspace/symbol')
override_lsp_picker('lsp_dynamic_workspace_symbols', 'workspace/symbol')

-- Workaround for nvim-telescope/telescope.nvim #2501
-- to prevent opening files in insert mode
vim.api.nvim_create_autocmd('WinLeave', {
  group = vim.api.nvim_create_augroup('TelescopeConfig', {}),
  callback = function(info)
    if vim.bo[info.buf].ft == 'TelescopePrompt' and vim.startswith(vim.fn.mode(), 'i') then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'in', false)
    end
  end,
})

-- Dropdown layout for telescope
local layout_dropdown = {
  previewer = false,
  layout_config = {
    width = 0.5,
    height = 0.5,
  },
}

telescope.setup {
  defaults = {
    prompt_prefix = static.icons.Magnify,
    selection_caret = static.icons.ArrowRight,
    borderchars = static.borders[border],
    results_title = false,
    layout_strategy = 'flex',
    layout_config = {
      width = 0.87,
      height = 0.8,
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
      },
      vertical = {
        prompt_position = 'top',
        mirror = true,
      },
    },
    sorting_strategy = 'ascending',
    file_ignore_patterns = { '.git/', '%.pdf', '%.o', '%.zip' },
    mappings = {
      i = {
        ['<M-c>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
        ['<M-l>'] = actions.smart_add_to_loclist + actions.open_loclist,
      },

      n = {
        ['q'] = actions.close,
        ['<esc>'] = actions.close,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<M-c>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
        ['<M-l>'] = actions.smart_add_to_loclist + actions.open_loclist,
      },
    },
  },
  pickers = {
    colorscheme = { enable_preview = true },
    commands = layout_dropdown,
    command_history = layout_dropdown,
    filetypes = layout_dropdown,
    keymaps = layout_dropdown,
    lsp_references = {
      include_current_line = true,
      jump_type = 'never',
    },
    lsp_definitions = {
      jump_type = 'never',
    },
    vim_options = layout_dropdown,
    registers = layout_dropdown,
    reloader = layout_dropdown,
    search_history = layout_dropdown,
    spell_suggest = layout_dropdown,
  },
  extensions = {
    undo = {
      use_delta = true,
      mappings = {
        i = {
          ['<CR>'] = require('telescope-undo.actions').restore,
        },
        n = {
          ['<CR>'] = require('telescope-undo.actions').restore,
          ['ya'] = require('telescope-undo.actions').yank_additions,
          ['yd'] = require('telescope-undo.actions').yank_deletions,
        },
      },
    },
  },
}

telescope.load_extension 'undo'
telescope.load_extension 'notify'
