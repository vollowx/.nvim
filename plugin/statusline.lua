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
  local added = diff.added or 0
  local changed = diff.changed or 0
  local removed = diff.removed or 0
  if added == 0 and removed == 0 and changed == 0 then return '' end
  return string.format(
    '+%s~%s-%s',
    utils.stl.hl(tostring(added), 'StatusLineGitAdded'),
    utils.stl.hl(tostring(changed), 'StatusLineGitChanged'),
    utils.stl.hl(tostring(removed), 'StatusLineGitRemoved')
  )
end

---Get string representation of current git branch
---@return string
function statusline.branch()
  ---@diagnostic disable-next-line: undefined-field
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
    or utils.git.branch()
  return branch == '' and '' or utils.stl.hl('#', 'StatusLineFaded') .. branch
end

---Get current filetype
---@return string
function statusline.ft()
  return vim.bo.ft == '' and '' or vim.bo.ft:gsub('^%l', string.upper)
end

---@type table<string, fun(): string>
---@diagnostic disable: undefined-field
statusline.flags = {
  md_captitle = function()
    return vim.bo.ft == 'markdown' and vim.b.captitle and 'md-cap-title' or ''
  end,
  lsp_autofmt = function()
    return vim.b.lsp_autofmt_enabled and 'lsp-auto-format' or ''
  end,
}
---@diagnostic enable: undefined-field

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
  add_section(statusline.flags.md_captitle())
  add_section(statusline.flags.lsp_autofmt())
  return vim.tbl_isempty(info) and ''
    or string.format('(%s) ', table.concat(info, ', '))
end

---Get string representation of diagnostics for current buffer
---@return string
function statusline.diag()
  local diagnostics = vim.diagnostic.get(0)
  local diagnostics_workspace = vim.diagnostic.get(nil)
  local counts = { 0, 0, 0, 0 }
  local counts_workspace = { 0, 0, 0, 0 }
  for _, diagnostic in ipairs(diagnostics) do
    counts[diagnostic.severity] = counts[diagnostic.severity] + 1
  end
  for _, diagnostic in ipairs(diagnostics_workspace) do
    counts_workspace[diagnostic.severity] = counts_workspace[diagnostic.severity]
      + 1
  end
  ---@param severity string
  ---@return string
  local function get_diagnostics_str(severity)
    local severity_num = vim.diagnostic.severity[severity:upper()]
    local count = counts[severity_num]
    local count_workspace = counts_workspace[severity_num]
    if count + count_workspace == 0 then return '' end
    return utils.stl.hl(
      get_sign_text('DiagnosticSign' .. severity),
      'StatusLineDiagnostic' .. severity
    ) .. utils.stl.hl(
      string.format('%d/%d', count, count_workspace),
      'StatusLineFaded'
    )
  end
  local result = ''
  for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
    local diag_str = get_diagnostics_str(severity)
    if diag_str ~= '' then
      result = result .. (result == '' and '' or ' ') .. diag_str
    end
  end
  return result == '' and '' or result .. ' '
end

---@class lsp_progress_data_t
---@field client_id integer
---@field result lsp_progress_data_result_t

---@class lsp_progress_data_result_t
---@field token integer
---@field value lsp_progress_data_result_value_t

---@class lsp_progress_data_result_value_t
---@field kind 'begin'|'report'|'end'
---@field title string
---@field message string?
---@field percentage integer?

local lsp_prog_data ---@type lsp_progress_data_t?
local report_time ---@type integer?
vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Update LSP progress info for the status line.',
  group = vim.api.nvim_create_augroup('StatusLineUpdateLspProgress', {}),
  callback = function(info)
    local data = info.data
    -- Filter out-of-order progress updates
    if
      lsp_prog_data
      and lsp_prog_data.client_id == data.client_id
      and lsp_prog_data.result.value.title == data.result.value.title
      and (data.result.value.percentage or 100)
        < (lsp_prog_data.result.value.percentage or 0)
    then
      return
    end
    lsp_prog_data = data
    report_time = vim.uv.hrtime()
    if data.result.value.kind == 'end' then
      local _report_time = report_time
      lsp_prog_data.result.value.message =
        vim.trim(utils.static.icons.diagnostics.Ok)
      -- Clear client message after a short time if received an 'end' message
      vim.defer_fn(function()
        -- No new report since the timer was set
        if _report_time == report_time then
          lsp_prog_data = nil
          vim.cmd.redrawstatus { bang = true }
        end
      end, 2048)
    end
    vim.cmd.redrawstatus { bang = true }
  end,
})

---@return string
function statusline.lsp_progress()
  if not lsp_prog_data then return '' end
  local value = lsp_prog_data.result.value
  return utils.stl.hl(
    string.format(
      '%s: %s%s%s ',
      vim.lsp.get_client_by_id(lsp_prog_data.client_id).name,
      value.title,
      value.message and string.format(' %s', value.message) or '',
      value.percentage and string.format(' [%d%%%%]', value.percentage) or ''
    ),
    'StatusLineFaded'
  )
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align        = '%=',
  diag         = '%{%v:lua.statusline.diag()%}',
  fname        = ' %#StatusLineStrong#%t%* ',
  fname_nc     = ' %#StatusLineWeak#%t%* ',
  info         = '%{%v:lua.statusline.info()%}',
  lsp_progress = '%{%v:lua.statusline.lsp_progress()%}',
  mode         = '%{%v:lua.statusline.mode()%}',
  padding      = '%#None#  %*',
  pos          = '%#StatusLineFaded#%l:%c%* ',
  truncate     = '%<',
}
-- stylua: ignore end

local groupid = vim.api.nvim_create_augroup('StatusLine', {})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'CursorMoved' }, {
  group = groupid,
  callback = function()
    vim.wo.statusline = table.concat {
      components.padding,
      components.mode,
      components.fname,
      components.info,
      components.align,
      components.truncate,
      components.lsp_progress,
      components.diag,
      components.pos,
      components.padding,
    }
  end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = groupid,
  callback = function()
    vim.wo.statusline = table.concat {
      components.padding,
      components.fname_nc,
      components.align,
      components.truncate,
      components.pos,
      components.padding,
    }
  end,
})
vim.api.nvim_create_autocmd({ 'FileChangedShellPost', 'DiagnosticChanged' }, {
  group = groupid,
  command = 'redrawstatus',
})
