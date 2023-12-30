local M = {}

---Returns whether the current buffer has treesitter enabled
---@param buf integer? default: current buffer
---@return boolean
function M.is_active(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) then return false end
  local ok = pcall(vim.treesitter.get_parser, buf, vim.b[buf].ft)
  return ok and true or false
end

return M
