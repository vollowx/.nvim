local utils = require 'utils'

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
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
  vim.keymap.set('n', 'gr', vim.lsp.buf.rename)
  vim.keymap.set('n', 'ge', vim.diagnostic.open_float)
  vim.keymap.set('n', 'gE', vim.diagnostic.setqflist)
  vim.keymap.set({ 'n', 'x' }, 'gF', vim.lsp.buf.format)
  vim.keymap.set('n', '[e', utils.keymap.count_wrap(vim.diagnostic.goto_prev))
  vim.keymap.set('n', ']e', utils.keymap.count_wrap(vim.diagnostic.goto_next))
  vim.keymap.set('n', '[E', utils.keymap.count_wrap(goto_diagnostic('prev', 'ERROR')))
  vim.keymap.set('n', ']E', utils.keymap.count_wrap(goto_diagnostic('next', 'ERROR')))
  vim.keymap.set('n', '[W', utils.keymap.count_wrap(goto_diagnostic('prev', 'WARN')))
  vim.keymap.set('n', ']W', utils.keymap.count_wrap(goto_diagnostic('next', 'WARN')))
  vim.keymap.set('n', '[I', utils.keymap.count_wrap(goto_diagnostic('prev', 'INFO')))
  vim.keymap.set('n', ']I', utils.keymap.count_wrap(goto_diagnostic('next', 'INFO')))
  vim.keymap.set('n', '[H', utils.keymap.count_wrap(goto_diagnostic('prev', 'HINT')))
  vim.keymap.set('n', ']H', utils.keymap.count_wrap(goto_diagnostic('next', 'HINT')))
  vim.keymap.set('n', 'gR', vim.lsp.buf.references)
  vim.keymap.set('n', 'gd', if_supports_lsp_method('textDocument/definition', 'definition', 'gd'), { expr = true })
  vim.keymap.set('n', 'gD', if_supports_lsp_method('textDocument/typeDefinition', 'type_definition', 'gD'), { expr = true })
  vim.keymap.set('n', 'K', if_supports_lsp_method('textDocument/hover', 'hover', 'K'), { expr = true })
  -- stylua: ignore end
end

---Set up LSP and diagnostic
---@return nil
local function setup() setup_keymaps() end

return {
  setup = setup,
}
