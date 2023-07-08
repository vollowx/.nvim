local fmt = string.format

---@class fallbak_tbl_t each key shares a default / fallback pattern table
---that can be used for pattern matching if corresponding key is not present
---or non patterns stored in the key are matched
---@field __content table closing patterns for each filetype
---@field __default table
local fallback_tbl_t = {}

function fallback_tbl_t:__index(k)
  return fallback_tbl_t[k] or self:fallback(k)
end

function fallback_tbl_t:__newindex(k, v)
  self.__content[k] = v
end

---Get the table with the fallback patterns for kdest
---@param k string key
---@return table concatenated table
function fallback_tbl_t:fallback(k)
  local dest = self.__content[k]
  local default = self.__default
  if dest and default then
    if vim.tbl_islist(dest) and vim.tbl_islist(default) then
      return vim.list_extend(dest, default)
    else
      dest = vim.tbl_deep_extend('keep', dest, default)
      return dest
    end
  elseif dest then
    return dest
  elseif default then
    return default
  end
  return {}
end

---Create a new shared table
---@param args table
---@return fallbak_tbl_t
function fallback_tbl_t:new(args)
  args = args or {}
  local fallback_tbl = {
    __content = args.content or {},
    __default = args.default or {},
  }
  return setmetatable(fallback_tbl, self)
end

-- stylua: ignore start
local patterns = fallback_tbl_t:new({
  default = { '%)', '%]', '}', '"', "'", '`', ',', ';', '%.' },
  content = {
    c = { '%*/' },
    cpp = { '%*/' },
    lua = { '%]%]' },
    python = { '"""', "'''" },
    markdown = {
      '\\right\\rfloor',
      '\\right\\rceil',
      '\\right\\vert',
      '\\right\\Vert',
      '\\right%)',
      '\\right%]',
      '\\right}',
      '\\right>',
      '\\%]',
      '\\%)',
      '\\}',
      '-->',
      '%*%*%*',
      '%*%*',
      '%*',
      '%$',
      '|',
    },
    tex = {
      '\\right\\rfloor',
      '\\right\\rceil',
      '\\right\\vert',
      '\\right\\Vert',
      '\\right%)',
      '\\right%]',
      '\\right}',
      '\\right>',
      '\\%]',
      '\\%)',
      '\\}',
      '%$',
    },
  },
})

local opening_pattern_lookup_tbl = {
  ["'"]               = "'",
  ['"']               = '"',
  [',']               = '.',
  [';']               = '.',
  ['`']               = '`',
  ['|']               = '|',
  ['}']               = '{',
  ['%.']              = '.',
  ['%$']              = '%$',
  ['%)']              = '%(',
  ['%]']              = '%[',
  ['%*']              = '%*',
  ['%*%*']            = '%*%*',
  ['%*%*%*']          = '%*%*%*',
  ['"""']             = '"""',
  ["'''"]             = "'''",
  ['%*/']             = '/%*',
  ['\\}']             = '\\{',
  ['-->']             = '<!--',
  ['\\%)']            = '\\%(',
  ['\\%]']            = '\\%[',
  ['%]%]']            = '--%[%[',
  ['\\right}']        = '\\left{',
  ['\\right>']        = '\\left<',
  ['\\right%)']       = '\\left%(',
  ['\\right%]']       = '\\left%[',
  ['\\right\\vert']   = '\\left\\vert',
  ['\\right\\Vert']   = '\\left\\lVert',
  ['\\right\\rceil']  = '\\left\\lceil',
  ['\\right\\rfloor'] = '\\left\\lfloor',
}
-- stylua: ignore end

---Get the index where Shift-Tab should jump to
---1. If there is only whitespace characters or no character in between
---   the opening and closing pattern, jump to the end of the whitespace
---   characters (i.e. right before the closing pattern)
---
---       1.1. Special case: if there is exactly two whitespace characters,
---            jump to the middle of the two whitespace characters
---
---2. If there is contents (non-whitespace characters) in between the
---   opening and closing pattern, jump to the end of the contents
---@param leading any leading texts on current line
---@param closing_pattern any closing pattern
---@param cursor number[] cursor position
---@return number[] cursor position after jump
local function jumpin_idx(leading, closing_pattern, cursor)
  local opening_pattern = opening_pattern_lookup_tbl[closing_pattern]

  -- Case 1
  local _, _, content_str, closing_pattern_str =
    leading:find(fmt('%s(%s)(%s)$', opening_pattern, '%s*', closing_pattern))
  if content_str == nil or closing_pattern_str == nil then
    _, _, content_str, closing_pattern_str =
      leading:find(fmt('^(%s)(%s)$', '%s*', closing_pattern))
  end

  if content_str and closing_pattern_str then
    -- Case 1.1
    if #content_str == 2 then
      return { cursor[1], cursor[2] - #closing_pattern_str - 1 }
    else
      return { cursor[1], cursor[2] - #closing_pattern_str }
    end
  end

  -- Case 2
  _, _, _, closing_pattern_str = leading:find(
    fmt(
      '%s%s(%s)$',
      opening_pattern .. '%s*',
      '.*%S',
      '%s*' .. closing_pattern .. '%s*'
    )
  )

  if content_str == nil or closing_pattern_str == nil then
    _, _, closing_pattern_str =
      leading:find(fmt('%s(%s)$', '%S', '%s*' .. closing_pattern .. '%s*'))
  end

  return { cursor[1], cursor[2] - #closing_pattern_str }
end

local get_jump_pos = {
  ---Getting the jump position for Tab
  ---@return number[]? cursor position after jump; false if no jump
  ['<Tab>'] = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = vim.api.nvim_get_current_line()
    local trailing = current_line:sub(cursor[2] + 1, -1)
    local leading = current_line:sub(1, cursor[2])

    -- Do not jump if the cursor is at the beginning/end of the current line
    if leading:match('^%s*$') or trailing == '' then
      return
    end

    for _, pattern in ipairs(patterns[vim.bo.ft or '']) do
      local _, jump_pos = trailing:find('^%s*' .. pattern)
      if jump_pos then
        return { cursor[1], cursor[2] + jump_pos }
      end
    end
  end,

  ---Getting the jump position for Shift-Tab
  ---@return number[]? cursor position after jump; false if no jump
  ['<S-Tab>'] = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = vim.api.nvim_get_current_line()
    local leading = current_line:sub(1, cursor[2])

    for _, pattern in ipairs(patterns[vim.bo.ft or '']) do
      local _, closing_pattern_end = leading:find(pattern .. '%s*$')
      if closing_pattern_end then
        return jumpin_idx(leading:sub(1, closing_pattern_end), pattern, cursor)
      end
    end
  end,
}

---Get the position to jump for Tab or Shift-Tab, perform the jump if
---there is a position to jump to, otherwise fallback (feedkeys)
---@param key string key to be pressed
local function do_key(key)
  local pos = get_jump_pos[key]()
  if pos then
    vim.api.nvim_win_set_cursor(0, pos)
  else
    local termcode = vim.api.nvim_replace_termcodes(key, true, true, true)
    vim.api.nvim_feedkeys(termcode, 'in', false)
  end
end

return {
  do_key = do_key,
  get_jump_pos = function(key)
    return get_jump_pos[key]()
  end,
}
