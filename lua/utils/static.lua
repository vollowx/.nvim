local M = {}

local langs_mt = {}
langs_mt.__index = langs_mt

---@param field string
---@return string[]
function langs_mt:list(field)
  local deduplist = {}
  local result = {}
  -- deduplication
  for _, info in pairs(self) do
    if type(info[field]) == 'string' then
      deduplist[info[field]] = true
    elseif type(info[field]) == 'table' then
      for _, name in pairs(info[field]) do
        deduplist[name] = true
      end
    end
  end
  for name, _ in pairs(deduplist) do
    table.insert(result, name)
  end
  return result
end

---@param field string
---@return table<string, string|string[]>
function langs_mt:map(field)
  local result = {}
  for lang, info in pairs(self) do
    result[lang] = info[field]
  end
  return result
end

M.langs = setmetatable(require('core.settings').langs, langs_mt)

-- stylua: ignore start
M.borders = {
  rounded               = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  single                = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double                = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  double_header         = { '═', '│', '─', '│', '╒', '╕', '┘', '└' },
  double_bottom         = { '─', '│', '═', '│', '┌', '┐', '╛', '╘' },
  double_horizontal     = { '═', '│', '═', '│', '╒', '╕', '╛', '╘' },
  double_left           = { '─', '│', '─', '│', '╓', '┐', '┘', '╙' },
  double_right          = { '─', '│', '─', '│', '┌', '╖', '╜', '└' },
  double_vertical       = { '─', '│', '─', '│', '╓', '╖', '╜', '╙' },
  vintage               = { '-', '|', '-', '|', '+', '+', '+', '+' },
  rounded_clc           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  single_clc            = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  double_clc            = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  double_header_clc     = { '╒', '═', '╕', '│', '┘', '─', '└', '│' },
  double_bottom_clc     = { '┌', '─', '┐', '│', '╛', '═', '╘', '│' },
  double_horizontal_clc = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
  double_left_clc       = { '╓', '─', '┐', '│', '┘', '─', '╙', '│' },
  double_right_clc      = { '┌', '─', '╖', '│', '╜', '─', '└', '│' },
  double_vertical_clc   = { '╓', '─', '╖', '│', '╜', '─', '╙', '│' },
  vintage_clc           = { '+', '-', '+', '|', '+', '-', '+', '|' },
  empty                 = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
}
-- stylua: ignore end

local icons_mt = {}

function icons_mt:__index(key)
  return self.debug[key]
    or self.diagnostics[key]
    or self.kinds[key]
    or self.ui[key]
    or icons_mt[key]
end

---Flatten the layered icons table into a single type-icon table.
---@return table<string, string>
function icons_mt:flatten()
  local result = {}
  for _, icons in pairs(self) do
    for type, icon in pairs(icons) do
      result[type] = icon
    end
  end
  return result
end

-- stylua: ignore start
M.icons = setmetatable(require('core.settings').icons, icons_mt)
-- stylua: ignore end

return M
