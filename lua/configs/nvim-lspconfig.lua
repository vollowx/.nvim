local static = require 'utils.static'
local server_configs = require 'configs.lsp-server-configs'

---Custom LSP appearance
---@return nil
local function custom_appearance()
  require('lspconfig.ui.windows').default_options.border = 'shadow'
  vim.diagnostic.config {
    underline = true,
    virtual_text = false,
    update_in_insert = true,
  }
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
  -- stylua: ignore start
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
  vim.keymap.set('n', 'ge', vim.diagnostic.open_float)
  vim.keymap.set('n', 'gE', vim.diagnostic.setqflist)
  vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
  vim.keymap.set('n', '[E', goto_diagnostic('prev', 'ERROR'))
  vim.keymap.set('n', ']E', goto_diagnostic('next', 'ERROR'))
  vim.keymap.set('n', '[W', goto_diagnostic('prev', 'WARN'))
  vim.keymap.set('n', ']W', goto_diagnostic('next', 'WARN'))
  vim.keymap.set('n', '[I', goto_diagnostic('prev', 'INFO'))
  vim.keymap.set('n', ']I', goto_diagnostic('next', 'INFO'))
  vim.keymap.set('n', '[H', goto_diagnostic('prev', 'HINT'))
  vim.keymap.set('n', ']H', goto_diagnostic('next', 'HINT'))
  -- stylua: ignore end
end

---Setup all LSP servers
local function lsp_setup()
  local lspconfig = require 'lspconfig'
  local ft_servers = static.langs:map 'lsp_server'
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
end

custom_appearance()
setup_keymaps()
lsp_setup()
