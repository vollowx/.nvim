-- stylua: ignore start
local todec = {
  ['0'] = 0,
  ['1'] = 1,
  ['2'] = 2,
  ['3'] = 3,
  ['4'] = 4,
  ['5'] = 5,
  ['6'] = 6,
  ['7'] = 7,
  ['8'] = 8,
  ['9'] = 9,
  ['A'] = 10,
  ['B'] = 11,
  ['C'] = 12,
  ['D'] = 13,
  ['E'] = 14,
  ['F'] = 15,
}

local tohex = {
  [0]  = '0',
  [1]  = '1',
  [2]  = '2',
  [3]  = '3',
  [4]  = '4',
  [5]  = '5',
  [6]  = '6',
  [7]  = '7',
  [8]  = '8',
  [9]  = '9',
  [10] = 'A',
  [11] = 'B',
  [12] = 'C',
  [13] = 'D',
  [14] = 'E',
  [15] = 'F',
}
-- stylua: ignore end

---Convert an integer from hexadecimal to decimal
---@param hex string
---@return integer dec
local function hex2dec(hex)
  local digit = 1
  local dec = 0

  while digit <= #hex do
    dec = dec + todec[string.sub(hex, digit, digit)] * 16 ^ (#hex - digit)
    digit = digit + 1
  end

  return dec
end

---Convert an integer from decimal to hexadecimal
---@param int integer
---@return string hex
local function dec2hex(int)
  local hex = ''

  while int > 0 do
    hex = tohex[int % 16] .. hex
    int = math.floor(int / 16)
  end

  return hex
end

---Convert a hex color to rgb color
---@param hex string hex code of the color
---@return integer[] rgb
local function hex2rgb(hex)
  local red = string.sub(hex, 1, 2)
  local green = string.sub(hex, 3, 4)
  local blue = string.sub(hex, 5, 6)

  return {
    hex2dec(red),
    hex2dec(green),
    hex2dec(blue),
  }
end

---Convert an rgb color to hex color
---@param rgb integer[]
---@return string
local function rgb2hex(rgb)
  local hex = {
    dec2hex(math.floor(rgb[1])),
    dec2hex(math.floor(rgb[2])),
    dec2hex(math.floor(rgb[3])),
  }
  hex = {
    string.rep('0', 2 - #hex[1]) .. hex[1],
    string.rep('0', 2 - #hex[2]) .. hex[2],
    string.rep('0', 2 - #hex[3]) .. hex[3],
  }
  return table.concat(hex, '')
end

---Blend two hex colors
---@param hex1 string the first color in hdex
---@param hex2 string the second color in hdex
---@param alpha number between 0~1, weight of the first color
---@return string hex_blended blended hex color
local function blend(hex1, hex2, alpha)
  local rgb1 = hex2rgb(hex1:gsub('#', '', 1))
  local rgb2 = hex2rgb(hex2:gsub('#', '', 1))

  local rgb_blended = {
    alpha * rgb1[1] + (1 - alpha) * rgb2[1],
    alpha * rgb1[2] + (1 - alpha) * rgb2[2],
    alpha * rgb1[3] + (1 - alpha) * rgb2[3],
  }

  return '#' .. rgb2hex(rgb_blended)
end

---Get background color in hex
---@param hlgroup_name string
---@param field string 'foreground' or 'background'
---@param fallback string|nil fallback color in hex, default to '#000000' if &bg is 'dark' and '#FFFFFF' if &bg is 'light'
---@return string hex color
local function get_hl(hlgroup_name, field, fallback)
  fallback = fallback or vim.opt.bg == 'dark' and '#000000' or '#FFFFFF'
  local has_hlgroup, hlgroup = pcall(vim.api.nvim_get_hl, 0, { name = hlgroup_name })
  if has_hlgroup and hlgroup[field] then return dec2hex(hlgroup[field]) end
  return fallback
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
    if cc_number and cc_number > 0 and (not cc_min or cc_number < cc_min) then cc_min = cc_number end
  end
  return cc_min
end

---Hide colorcolumn
---@param winid integer window handler
local function cc_conceal(winid)
  winid = winid or 0
  local new_winhl = (vim.wo[winid].winhl:gsub('ColorColumn:[^,]*', '') .. ',ColorColumn:')
    :gsub(',*$', '')
    :gsub('^,*', '')
    :gsub(',+', ',')
  if new_winhl ~= vim.wo[winid].winhl then vim.wo[winid].winhl = new_winhl end
end

---Show colorcolumn
---@param winid integer window handler
local function cc_show(winid)
  winid = winid or 0
  local new_winhl = (vim.wo[winid].winhl:gsub('ColorColumn:[^,]*', '') .. ',ColorColumn:_ColorColumn')
    :gsub(',*$', '')
    :gsub('^,*', '')
    :gsub(',+', ',')
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
      local normal_bg = get_hl('Normal', 'bg')
      local colorcolumn_bg = get_hl('ColorColumn', 'bg')
      if length < cc then
        vim.api.nvim_set_hl(0, '_ColorColumn', {
          bg = blend(colorcolumn_bg, normal_bg, (length - thresh) / (cc - thresh)),
        })
      else -- Show error color when length >= cc
        local warning_color = get_hl('Error', 'fg', '#FF0000')
        vim.api.nvim_set_hl(0, '_ColorColumn', {
          bg = blend(warning_color, normal_bg, 0.4),
        })
      end
      cc_show(0)
    end,
  })
end

cc_init()
cc_autocmd()
