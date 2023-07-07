local M = {}

---Set global mappings for the given modes.
---@param modes string
---@param lhs string
---@param rhs string
---@param opts table
function M.set(modes, lhs, rhs, opts)
  for _, mode in ipairs(vim.split(modes, "")) do
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

---Generate keymap options.
---@param override? table
function M.opt(override)
  return vim.tbl_extend('force', {
    noremap = true,
    silent = true,
  }, override and override or {})
end

return M
