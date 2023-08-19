local null_ls = require 'null-ls'
local null_ls_sources = require 'null-ls.sources'

---Check if null-ls supports a given method for a given filetype
---@param ft string filetype
---@param method string method
local function null_ls_supports(ft, method)
  return not vim.tbl_isempty(null_ls_sources.get_available(ft, method))
    and not vim.tbl_isempty(vim.lsp.get_clients { name = 'null-ls' })
end

---Disable other LSP's formatting capabilities if null-ls supports it
---@param tbl table table passed by event LspAttach
local function null_ls_disable_other_formatters(tbl)
  local ft = vim.bo[tbl.buf].ft
  local client = vim.lsp.get_client_by_id(tbl.data.client_id)
  if not client or client.name == 'null-ls' then return end
  if null_ls_supports(ft, 'NULL_LS_FORMATTING') then
    client.server_capabilities.documentFormattingProvider = false
  end
  if null_ls_supports(ft, 'NULL_LS_RANGE_FORMATTING') then
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

---Null-ls on-attach function
---@param _ table LSP client, ignored
---@param bufnr integer buffer number
local function null_ls_on_attach(_, bufnr)
  -- Disable other LSP's formatting capabilities if null-ls supports it
  local ft = vim.bo[bufnr].ft
  local active_clients = vim.lsp.get_clients { bufnr = bufnr }
  if null_ls_supports(ft, 'NULL_LS_FORMATTING') then
    for _, active_client in ipairs(active_clients) do
      if active_client.name ~= 'null-ls' then
        active_client.server_capabilities.documentFormattingProvider = false
      end
    end
  end
  if null_ls_supports(ft, 'NULL_LS_RANGE_FORMATTING') then
    for _, active_client in ipairs(active_clients) do
      if active_client.name ~= 'null-ls' then
        active_client.server_capabilities.documentRangeFormattingProvider =
          false
      end
    end
  end

  -- Setup autocmd to disable formatting capabilities of future LSP clients
  local augroup = 'NullLs' .. bufnr
  vim.api.nvim_create_augroup(augroup, { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    buffer = bufnr,
    group = augroup,
    callback = null_ls_disable_other_formatters,
  })
end

---Get null-ls config for a given source
---@param type string source type
---@param name string source name
local function null_ls_config_source(type, name)
  local ok, config =
    pcall(require, 'configs.null-ls-configs.' .. type .. '.' .. name)
  if not ok then return null_ls.builtins[type][name] end
  return config.config(null_ls.builtins[type][name])
end

---Get null-ls sources
---@return table null-ls sources
local function null_ls_get_sources()
  local sources = {}
  local langs = require('utils.static').langs
  local builtin_types = {
    'formatting',
    'diagnostics',
    'code_actions',
    'hover',
  }
  for _, type in ipairs(builtin_types) do
    local source_names = langs:list(type)
    for _, name in ipairs(source_names) do
      name = name:gsub('-', '_')
      table.insert(sources, null_ls_config_source(type, name))
    end
  end
  return sources
end

null_ls.setup {
  sources = null_ls_get_sources(),
  on_attach = function(client, bufnr)
    local lsp_default_config =
      require 'configs.lsp-server-configs.shared.default'
    lsp_default_config.on_attach(client, bufnr)
    null_ls_on_attach(client, bufnr)
  end,
}
