local M = {}

---Set abbreviation that only expand when the trigger is at the position of
---a command
---@param trig string
---@param command string
---@param opts table?
function M.command_abbrev(trig, command, opts)
  vim.keymap.set(
    'ca',
    trig,
    function() return vim.fn.getcmdcompltype() == 'command' and command or trig end,
    vim.tbl_deep_extend('keep', { expr = true }, opts or {})
  )
end

return M
