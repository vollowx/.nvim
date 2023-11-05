local utils = require 'utils'
local toggle_key = '<M-i>'

---@alias jobid integer
---@type table<string, fterm_t>
local lazygits = {}

---Toggle lazygit at project root or current working directory
---@param root string? path to the git repo, default to current project root path
---@return nil
local function lazygit_toggle(root)
  if not root then
    ---@diagnostic disable-next-line: undefined-field
    local cwd = vim.uv.cwd()
    root = utils.fs.proj_dir(cwd, { '.git/' }) or cwd
  end
  if root then
    if lazygits[root] then
      lazygits[root]:toggle()
    else
      lazygits[root] = utils.classes.fterm_t:new('lazygit', {
        winopts = { border = 'solid' },
        jobopts = { cwd = root },
        termopts = { toggle_keys = { toggle_key } },
      })
    end
  else
    vim.notify('[lazygit] vim.uv.cwd() failed!', vim.log.levels.WARN)
  end
end

vim.keymap.set('n', toggle_key, lazygit_toggle)

vim.api.nvim_create_user_command(
  'Lazygit',
  function(info) lazygit_toggle(info.fargs[1]) end,
  {
    nargs = '?',
    complete = 'dir',
    desc = 'Toggle lazygit window, optionally accept an argument as the git repo path.',
  }
)
