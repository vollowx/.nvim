local utils = require 'utils'

---@class lazyvim.util.terminal
---@overload fun(cmd: string|string[], opts: LazyTermOpts): LazyFloat
local M = setmetatable({}, {
  __call = function(m, ...) return m.open(...) end,
})

---@type table<string,LazyFloat>
local terminals = {}

---@class LazyTermOpts: LazyCmdOptions
---@field interactive? boolean

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyTermOpts
function M.open(cmd, opts)
  ---@diagnostic disable-next-line: undefined-field
  local cwd = vim.uv.cwd()
  opts = vim.tbl_deep_extend('force', {
    cwd = utils.fs.proj_dir(cwd, { '.git/' }) or cwd,
    ft = 'lazyterm',
    size = { width = 0.9, height = 0.9 },
  }, opts or {}, { persistent = true }) --[[@as LazyTermOpts]]

  local termkey = vim.inspect {
    cmd = cmd or 'shell',
    cwd = opts.cwd,
    env = opts.env,
    count = vim.v.count1,
  }

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require('lazy.util').float_term(cmd, opts)
    local buf = terminals[termkey].buf
    vim.b[buf].lazyterm_cmd = cmd

    vim.api.nvim_create_autocmd('BufEnter', {
      buffer = buf,
      callback = function() vim.cmd.startinsert() end,
    })
  end

  return terminals[termkey]
end

return M
