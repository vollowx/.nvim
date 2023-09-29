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
}

---Decide if pressing <Esc> in nvim builtin terminal should exit terminal mode
---caveat: does not work with `sudo [opts] <command>`
---@param pid integer? pid of a terminal job, default to jobpid(&channel)
---@param commands table<string, true> table of commands that if running, pressing <Esc> should exit terminal mode
---@return boolean? true if should exit terminal mode, nil if cannot decide
function M.shall_esc(pid, commands)
  pid = pid or vim.bo.channel == 0 and 0 or vim.fn.jobpid(vim.bo.channel)
  if pid == 0 then -- Invalid pid
    return
  end
  commands = vim.tbl_deep_extend('force', commands_shall_esc, commands or {})
  local c = vim.trim(vim.fn.system('ps h -o comm -g ' .. pid .. ' | tail -n1'))
  if vim.v.shell_error > 0 then return nil end
  return commands[c] ~= nil
end

return M
