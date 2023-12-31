local ls = require('luasnip')
local f = ls.function_node
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta

---Returns a string for indentation at the given depth
---@param depth number
---@return string
local function get_indent_str(depth)
  if depth <= 0 then
    return ''
  end

  local sw = vim.fn.shiftwidth()
  return vim.bo.expandtab and string.rep(' ', sw * depth)
    or string.rep('\t', math.floor(sw * depth / vim.bo.ts))
      .. string.rep(' ', sw * depth % vim.bo.ts)
end

---Returns a function node that returns a string for indentation at the given
---depth
---@param depth number|fun(...): number
---@param argnode_references number|table?
---@param node_opts table?
---@return table node
local function function_indent_node(depth, argnode_references, node_opts)
  return f(function(...)
    ---@diagnostic disable-next-line: param-type-mismatch
    return get_indent_str(type(depth) == 'function' and depth(...) or depth)
  end, argnode_references, node_opts)
end

---Returns function node that returns a quotation mark based on the number of
---double quotes and single quotes in the first 128 lines current buffer
---@param argnode_references number|table?
---@param opts table?
---@return table node
local function function_quotation_node(argnode_references, opts)
  return f(function()
    return require('snippets.utils.funcs').get_quotation_type()
  end, argnode_references, opts)
end

---Returns a dynamic node for suffix snippet
---@param jump_index number
---@param opening string
---@param closing string
---@return table node
local function simple_suffix_dynamic_node(jump_index, opening, closing)
  return d(jump_index or 1, function(_, snip)
    local symbol = snip.captures[1]
    if symbol == nil or not symbol:match('%S') then
      return sn(nil, { t(opening), i(1), t(closing) })
    end
    return sn(nil, { t(opening), t(symbol), t(closing) })
  end)
end

---A format node with repeat_duplicates set to true
local format_repeat_duplicates_node = ls.extend_decorator.apply(fmt, {
  repeat_duplicates = true,
})

---A format node with <> as placeholders and repeat_duplicates set to true
local format_angle_repeat_duplicates_node = ls.extend_decorator.apply(fmta, {
  repeat_duplicates = true,
})

return {
  idnt = function_indent_node,
  qt = function_quotation_node,
  sdn = simple_suffix_dynamic_node,
  fmtd = format_repeat_duplicates_node,
  fmtad = format_angle_repeat_duplicates_node,
}
