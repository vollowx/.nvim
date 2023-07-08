---Configuration for shfmt
---@param source table null-ls source
---@return table null-ls source
local function config(source)
  return source.with({
    extra_args = function(_)
      return { '--indent', vim.bo.et and tostring(vim.bo.ts) or '0' }
    end,
  })
end

return {
  config = config,
}
