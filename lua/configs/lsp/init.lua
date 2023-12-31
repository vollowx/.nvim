local default = require 'configs.lsp.default'

return setmetatable({}, {
  __index = function(self, key)
    local config_exists, config =
      pcall(require, 'configs.lsp.servers.' .. key)
    if not config_exists then
      config = vim.deepcopy(default)
    else
      config = vim.tbl_deep_extend('force', default, config)
    end
    self[key] = config
    return config
  end,
})
