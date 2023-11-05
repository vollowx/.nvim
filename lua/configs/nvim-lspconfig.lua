local static = require 'utils.static'
local server_configs = require 'configs.lsp-server-configs'

local border = require('init.settings').border

---Customize LspInfo floating window
local function lspconfig_info_win()
  -- setup LspInfo floating window border
  require('lspconfig.ui.windows').default_options.border = border
  -- reload LspInfo floating window on VimResized
  vim.api.nvim_create_autocmd('VimResized', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('LspInfoResize', {}),
    callback = function()
      if vim.bo.ft == 'lspinfo' then
        vim.api.nvim_win_close(0, true)
        vim.cmd 'LspInfo'
      end
    end,
  })
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

lspconfig_info_win()
lsp_setup()
