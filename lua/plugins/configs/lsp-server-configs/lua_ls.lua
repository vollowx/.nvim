---Get the path to a config file
---@param app string
---@return string
local function config_path(app)
  return string.format(
    '%s/.config/%s',
    os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') or '',
    app
  )
end

local nvimlib = vim.list_extend(
  vim.api.nvim_get_runtime_file('lua/', true),
  vim.fs.find({ 'lua' }, {
    type = 'directory',
    limit = math.huge,
    path = vim.fn.stdpath('data'),
  })
)
local neodevok, neodevcfg = pcall(require, 'neodev.config')
if neodevok then
  table.insert(nvimlib, neodevcfg.types())
end

---Check if a path is inside nvim's runtime paths
---@param path string
---@return boolean
local function inside_nvim_runtime_paths(path)
  for _, runtime_path in ipairs(vim.api.nvim_list_runtime_paths()) do
    if vim.startswith(path, runtime_path) then
      return true
    end
  end
  return false
end

return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        enable = true,
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_new_config = function(config, root_dir)
    if not root_dir then
      return
    end
    local settings = config.settings or {}
    if inside_nvim_runtime_paths(root_dir) then
      config.settings = vim.tbl_deep_extend('force', settings, {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = nvimlib,
          },
        },
      })
    -- Not using Awesome WM
    --[[ elseif vim.startswith(root_dir, config_path('awesome')) then
      config.settings = vim.tbl_deep_extend('force', settings, {
        Lua = {
          runtime = {
            path = {
              '/usr/share/awesome/lib',
              '/usr/share/awesome/themes',
            },
          },
          diagnostics = {
            globals = {
              'awesome',
              'client',
              'screen',
              'root',
            },
          },
        },
      }) ]]
    end
  end,
}
