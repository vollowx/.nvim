---Set attributes for a single snippet
---@param snip table
---@param attr table
local function snip_set_attr(snip, attr)
  for attr_key, attr_val in pairs(attr) do
    if type(snip[attr_key]) == 'table' and type(attr_val) == 'table' then
      snip[attr_key] = vim.tbl_deep_extend('keep', snip[attr_key], attr_val)
    else
      snip[attr_key] = attr_val
    end
  end
end

---Add attributes to a snippet group
---@param attr table
---@param snip_group table
---@return table
local function add_attr(attr, snip_group)
  for _, snip in ipairs(snip_group) do
    -- ls.multi_snippet
    if snip.v_snips then
      for _, s in ipairs(snip.v_snips) do
        snip_set_attr(s, attr)
      end
    else -- ls.snippet
      snip_set_attr(snip, attr)
    end
  end
  return snip_group
end

---Returns the depth of the current indent given the indent of the current line
---@param indent number|string
local function get_indent_depth(indent)
  if type(indent) == 'string' then
    indent = #indent:match('^%s*'):gsub('\t', string.rep(' ', vim.bo.ts))
  end
  if indent <= 0 then return 0 end
  local sts
  if vim.bo.sts > 0 then
    sts = vim.bo.sts
  elseif vim.bo.sw > 0 then
    sts = vim.bo.sw
  else
    sts = vim.bo.ts
  end
  return math.floor(indent / sts)
end

---Returns the character after the cursor
---@return string
local function get_char_after()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return line:sub(col, col)
end

return {
  snip_set_attr = snip_set_attr,
  add_attr = add_attr,
  get_char_after = get_char_after,
  get_indent_depth = get_indent_depth,
}
