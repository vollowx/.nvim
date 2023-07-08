---Configuration for black
---@param source table null-ls source
---@return table null-ls source
local function config(source)
  return source.with({
    extra_args = { '--line-length', '79' },
  })
end

return {
  config = config,
}
