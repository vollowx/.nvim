-- Colorschemes other than the default colorscheme looks bad when the terminal
-- does not support truecolor
if vim.env.COLORTERM ~= 'truecolor' and vim.fn.has 'gui_running' == 0 then
  return
end

local utils = require 'utils'
local colors_file =
  vim.fs.joinpath(vim.fn.stdpath 'state' --[[@as string]], 'colors.json')

-- 1. Restore dark/light background and colorscheme from json so that nvim
--    "remembers" the background and colorscheme when it is restarted.
-- 2. Spawn setbg/setcolors on colorscheme change to make other nvim instances
--    and system color consistent with the current nvim instance.

local saved = utils.json.read(colors_file)
saved.bg = saved.bg or 'dark'
saved.colors_name = saved.colors_name or 'catppuccin-mocha'

if saved.bg and saved.bg ~= vim.go.bg then vim.go.bg = saved.bg end

if saved.colors_name and saved.colors_name ~= vim.g.colors_name then
  vim.cmd.colorscheme {
    args = { saved.colors_name },
    mods = { emsg_silent = true },
  }
end

vim.api.nvim_create_autocmd('Colorscheme', {
  group = vim.api.nvim_create_augroup('ColorSwitch', {}),
  desc = 'Spawn setbg/setcolors on colorscheme change.',
  callback = function()
    if vim.g.script_set_bg or vim.g.script_set_colors then return end

    local data = utils.json.read(colors_file)
    if data.colors_name ~= vim.g.colors_name or data.bg ~= vim.go.bg then
      data.colors_name = vim.g.colors_name
      data.bg = vim.go.bg
      if not utils.json.write(colors_file, data) then return end
    end

    pcall(vim.system, { 'setbg', vim.go.bg })
    pcall(vim.system, { 'setcolors', vim.g.colors_name })
  end,
})
