_G.statusline = {}
local utils = require 'utils'

---@type table<string, string>
local signs_text_cache = {}

---@param name string
---@return string
local function get_sign_text(name)
  if not signs_text_cache[name] then
    local sign_def = vim.fn.sign_getdefined(name)[1]
    signs_text_cache[name] = sign_def and sign_def.text
  end
  return signs_text_cache[name] or ''
end

-- stylua: ignore start
local modes = {
  ['n']    = 'NO',
  ['no']   = 'OP',
  ['nov']  = 'OC',
  ['noV']  = 'OL',
  ['no'] = 'OB',
  ['']   = 'VB',
  ['niI']  = 'IN',
  ['niR']  = 'RE',
  ['niV']  = 'RV',
  ['nt']   = 'NT',
  ['ntT']  = 'TM',
  ['v']    = 'VI',
  ['vs']   = 'VI',
  ['V']    = 'VL',
  ['Vs']   = 'VL',
  ['s']  = 'VB',
  ['s']    = 'SE',
  ['S']    = 'SL',
  ['']   = 'SB',
  ['i']    = 'IN',
  ['ic']   = 'IC',
  ['ix']   = 'IX',
  ['R']    = 'RE',
  ['Rc']   = 'RC',
  ['Rx']   = 'RX',
  ['Rv']   = 'RV',
  ['Rvc']  = 'RC',
  ['Rvx']  = 'RX',
  ['c']    = 'CO',
  ['cv']   = 'CV',
  ['r']    = 'PR',
  ['rm']   = 'PM',
  ['r?']   = 'P?',
  ['!']    = 'SH',
  ['t']    = 'TE',
}
-- stylua: ignore end

---Get string representation of the current mode
---@return string
function statusline.mode()
  local hl = vim.bo.mod and 'StatusLineHeaderModified' or 'StatusLineHeader'
  return utils.stl.hl(' ' .. modes[vim.fn.mode()] .. ' ', hl)
end

---Get diff stats for current buffer
---@return string
function statusline.gitdiff()
  -- Integration with gitsigns.nvim
  ---@diagnostic disable-next-line: undefined-field
  local diff = vim.b.gitsigns_status_dict or utils.git.diffstat()
  if diff.added == 0 and diff.removed == 0 and diff.changed == 0 then return '' end
  return string.format(
    '+%s~%s-%s',
    utils.stl.hl(tostring(diff.added), 'StatusLineGitAdded'),
    utils.stl.hl(tostring(diff.changed), 'StatusLineGitChanged'),
    utils.stl.hl(tostring(diff.removed), 'StatusLineGitRemoved')
  )
end

---Get string representation of current git branch
---@return string
function statusline.branch()
  ---@diagnostic disable-next-line: undefined-field
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head or utils.git.branch()
  return branch == '' and '' or '#' .. branch
end

---Get current filetype
---@return string
function statusline.ft() return vim.bo.ft == '' and '' or vim.bo.ft:gsub('^%l', string.upper) end

---Additional info for the current buffer enclosed in parentheses
---@return string
function statusline.info()
  if vim.bo.bt ~= '' then return '' end
  local info = {}
  ---@param section string
  local function add_section(section)
    if section ~= '' then table.insert(info, section) end
  end
  add_section(statusline.ft())
  add_section(statusline.branch())
  add_section(statusline.gitdiff())
  return vim.tbl_isempty(info) and '' or string.format('(%s)', table.concat(info, ', '))
end

---Get string representation of diagnostics for current buffer
---@return string
function statusline.diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  local diagnostics_workspace = vim.diagnostic.get(nil)
  local counts = { 0, 0, 0, 0 }
  local counts_workspace = { 0, 0, 0, 0 }
  for _, diagnostic in ipairs(diagnostics) do
    counts[diagnostic.severity] = counts[diagnostic.severity] + 1
  end
  for _, diagnostic in ipairs(diagnostics_workspace) do
    counts_workspace[diagnostic.severity] = counts_workspace[diagnostic.severity] + 1
  end
  ---@param severity string
  ---@return string
  local function get_diagnostics_str(severity)
    local severity_num = vim.diagnostic.severity[severity:upper()]
    local count = counts[severity_num]
    local count_workspace = counts_workspace[severity_num]
    if count + count_workspace == 0 then return '' end
    return utils.stl.hl(
      get_sign_text('DiagnosticSign' .. severity) .. string.format('%d/%d', count, count_workspace),
      'StatusLineDiagnostic' .. severity
    )
  end
  local result = ''
  for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
    local diag_str = get_diagnostics_str(severity)
    if diag_str ~= '' then result = result .. (result == '' and '' or ' ') .. diag_str end
  end
  return result
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align       = '%=',
  diagnostics = '%{%v:lua.statusline.diagnostics()%} ',
  fname       = ' %#StatusLineStrong#%t%* ',
  fname_nc    = ' %#StatusLineWeak#%t%* ',
  info        = '%{%v:lua.statusline.info()%}',
  mode        = '%{%v:lua.statusline.mode()%}',
  padding     = '%#StatusLine#  %*',
  position    = '%#StatusLineFaded#%l:%c%* ',
  truncate    = '%<',
}
-- stylua: ignore end

local groupid = vim.api.nvim_create_augroup('StatusLine', {})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'CursorMoved' }, {
  group = groupid,
  callback = function()
    vim.wo.statusline = table.concat {
      components.padding,
      components.mode,
      components.truncate,
      components.fname,
      components.info,
      components.align,
      components.diagnostics,
      components.position,
      components.padding,
    }
  end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = groupid,
  callback = function()
    vim.wo.statusline = table.concat {
      components.padding,
      components.truncate,
      components.fname_nc,
      components.align,
      components.padding,
    }
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = groupid,
  command = 'redrawstatus',
})
