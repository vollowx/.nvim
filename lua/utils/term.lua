local M = {}

local commands_shall_esc = {
  sh = true,
  zsh = true,
  bash = true,
  dash = true,
  fish = true,
  less = true,
  gawk = true,
  python = true,
  python3 = true,
  ipython = true,
  ipython3 = true,
  lua = true,
}

---Decide if pressing <Esc> in nvim builtin terminal should exit terminal mode
---caveat: does not work with `sudo [opts] <command>`
---@return boolean true if should exit terminal mode
function M.shall_esc()
  local chan_valid, pid = pcall(vim.fn.jobpid, vim.bo.channel)
  if not chan_valid then return true end
  local c = vim.trim(vim.fn.system('ps h -o comm -g ' .. pid .. ' | tail -n1'))
  return vim.v.shell_error > 0 or commands_shall_esc[c] ~= nil
end

return M
