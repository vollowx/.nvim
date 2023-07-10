local M = {}
local utils = require('utils')

---Check if the current line is a markdown code block, using regex
---to check each line
---@param lnum integer? default to current line number
function M.in_codeblock_regex(lnum, buf)
  buf = buf or 0
  lnum = lnum or vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(buf, 0, lnum - 1, false)
  local result = false
  for _, line in ipairs(lines) do
    if line:match('^```') then
      result = not result
    end
  end
  return result
end

---Check if the current line is a markdown code block
---@param lnum integer? default to current line number
function M.in_codeblock(lnum, buf)
  buf = buf or 0
  lnum = lnum or vim.api.nvim_win_get_cursor(0)[1]
  if utils.treesitter.ts_active(buf) then
    return utils.treesitter.in_tsnode('fenced_code_block', { lnum, 0 }, buf)
  end
  return M.in_codeblock_regex(lnum, buf)
end

---Returns whether the cursor is in a math zone
---@return boolean
function M.in_mathzone()
  return utils.ft.tex.in_mathzone()
end

---Returns whether the cursor is in normal zone
---(not in math zone or code block)
---@return boolean
function M.in_normalzone()
  return not M.in_mathzone() and not M.in_codeblock()
end

return M
