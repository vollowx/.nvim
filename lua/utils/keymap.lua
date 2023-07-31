local M = {}

---Set keymap
---@param modes string
---@param l string
---@param r string|function
---@param opts table
function M.set(modes, l, r, opts)
  opts = opts or {}
  for _, mode in ipairs(vim.split(modes, '')) do
    vim.keymap.set(mode, l, r, opts)
  end
end

return M
