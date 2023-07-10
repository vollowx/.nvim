local default = require 'plugins.configs.lsp-server-configs.shared.default'

return setmetatable({}, {
  __index = function(self, key)
    local config_exists, config = pcall(require, 'plugins.configs.lsp-server-configs.' .. key)
    if not config_exists then
      config = vim.deepcopy(default)
    else
      config = vim.tbl_deep_extend('force', default, config)
    end
    self[key] = config
    return config
  end,
})
