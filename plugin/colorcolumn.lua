local hl = require 'utils.hl'

---Get background color in hex
---@param hlgroup_name string
---@param field string 'foreground' or 'background'
---@param fallback string|nil fallback color in hex, default to '#000000' if &bg is 'dark' and '#FFFFFF' if &bg is 'light'
---@return string hex color
local function get_hl_hex(hlgroup_name, field, fallback)
  fallback = fallback or vim.opt.bg == 'dark' and '#000000' or '#FFFFFF'
  if not vim.fn.hlexists(hlgroup_name) then return fallback end
  -- Do not use link = false here, because nvim will return the highlight
  -- attributes of the remapped hlgroup if link = false when winhl is set
  -- e.g. when winhl=ColorColumn:FooBar, nvim will return the attributes of
  -- FooBar instead of ColorColumn with link = false, but return the
  -- attributes of ColorColumn with link = true
  local attr_val = vim.api.nvim_get_hl(0, { name = hlgroup_name })[field]
  return attr_val and hl.dec2hex(attr_val) or fallback
end

---Resolve the colorcolumn value
---@param cc string|nil
---@return integer|nil cc_number smallest integer >= 0 or nil
local function cc_resolve(cc)
  if not cc or cc == '' then return nil end
  local cc_tbl = vim.split(cc, ',')
  local cc_min = nil
  for _, cc_str in ipairs(cc_tbl) do
    local cc_number = tonumber(cc_str)
    if vim.startswith(cc_str, '+') or vim.startswith(cc_str, '-') then
      cc_number = vim.bo.tw > 0 and vim.bo.tw + cc_number or nil
    end
    if cc_number and cc_number > 0 and (not cc_min or cc_number < cc_min) then
      cc_min = cc_number
    end
  end
  return cc_min
end

---Hide colorcolumn
---@param winid integer window handler
local function cc_conceal(winid)
  winid = winid or 0
  local new_winhl = (
    vim.wo[winid].winhl:gsub('ColorColumn:[^,]*', '') .. ',ColorColumn:'
  ):gsub(',*$', ''):gsub('^,*', ''):gsub(',+', ',')
  if new_winhl ~= vim.wo[winid].winhl then vim.wo[winid].winhl = new_winhl end
end

---Show colorcolumn
---@param winid integer window handler
local function cc_show(winid)
  winid = winid or 0
  local new_winhl = (
    vim.wo[winid].winhl:gsub('ColorColumn:[^,]*', '')
    .. ',ColorColumn:_ColorColumn'
  ):gsub(',*$', ''):gsub('^,*', ''):gsub(',+', ',')
  if new_winhl ~= vim.wo[winid].winhl then vim.wo[winid].winhl = new_winhl end
end

---Conceal colorcolumn in each window
local function cc_init()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    cc_conceal(win)
  end
end

---Create autocmds for concealing / showing colorcolumn
local function cc_autocmd()
  local id = vim.api.nvim_create_augroup('AutoColorColumn', {})
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinLeave' }, {
    group = id,
    callback = function()
      if vim.fn.win_gettype() == '' then cc_conceal(0) end
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMovedI', 'InsertEnter' }, {
    group = id,
    callback = function()
      local cc = cc_resolve(vim.wo.cc)
      if not cc or vim.fn.win_gettype() ~= '' then
        cc_conceal(0)
        return
      end

      -- Fix 'E976: using Blob as a String' after select a snippet
      -- entry from LSP server using omnifunc (<C-x><C-o>)
      local length = vim.fn.strdisplaywidth(vim.fn.getline '.')
      local thresh = math.floor(0.75 * cc)
      if length < thresh then
        cc_conceal(0)
        return
      end

      -- Show blended color when len < cc
      local normal_bg = get_hl_hex('Normal', 'bg')
      local colorcolumn_bg = get_hl_hex('ColorColumn', 'bg')
      if length < cc then
        vim.api.nvim_set_hl(0, '_ColorColumn', {
          bg = hl.cblend(
            colorcolumn_bg,
            normal_bg,
            (length - thresh) / (cc - thresh)
          ).dec,
        })
      else -- Show error color when length >= cc
        local warning_color = get_hl_hex('Error', 'fg', '#FF0000')
        vim.api.nvim_set_hl(0, '_ColorColumn', {
          bg = hl.cblend(warning_color, normal_bg, 0.4).dec,
        })
      end
      cc_show(0)
    end,
  })
end

cc_init()
cc_autocmd()
