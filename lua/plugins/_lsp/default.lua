---@param client lsp.Client LSP client attached
---@param bufnr integer buffer handler
---@return nil
---@diagnostic disable-next-line unused-local
local function on_attach(client, bufnr) vim.lsp.inlay_hint.enable(0, true) end

-- Merge default capabilities with extra capabilities provided by cmp-nvim-lsp
local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  }
)

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

return default_config
