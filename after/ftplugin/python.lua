local cursorline = vim.opt_local.cursorline:get()
local cursorlineopt = vim.opt_local.cursorlineopt:get()
if cursorline and (cursorlineopt == 'both' or cursorlineopt == 'line') then
  vim.opt_local.cursorcolumn = true
end
