local M = {}

--- Trigger an user event
---@param event string The event name to be appended to Astro
function M.release(event)
  vim.schedule(function() vim.api.nvim_exec_autocmds("User", {
    pattern = "Nv" .. event,
    modeline = false
  }) end)
end

return M
