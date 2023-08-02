local toggleterm = require 'toggleterm'
local terminal = require 'toggleterm.terminal'

local border = require('core.settings').border

toggleterm.setup {
  open_mapping = false,
  shade_terminals = false,
  start_in_insert = false,
  hide_numbers = true,
  autochdir = false,
  persist_mode = false,
  persist_size = false,
  direction = 'horizontal',
  float_opts = {
    border = border,
    width = function() return math.floor(vim.go.columns * 0.7) end,
    height = function() return math.floor(vim.go.lines * 0.7) end,
    winblend = 0,
  },
  size = function(term)
    if term.direction == 'horizontal' then
      return vim.go.lines * 0.4
    elseif term.direction == 'vertical' then
      return vim.go.columns * 0.35
    end
  end,
  highlights = {
    NormalFloat = { link = 'NormalFloat' },
    FloatBorder = { link = 'FloatBorder' },
    WinBarActive = { link = 'WinBar' },
    WinBarInactive = { link = 'WinBarNC' },
    MatchParen = { link = 'None' },
    StatusLine = { link = 'StatusLine' },
  },
  winbar = {
    enabled = false,
  },
  on_open = function() vim.cmd 'silent! normal! 0' end,
}

local num_lazygits = 0
local last_visited_git_repo = nil

---@type table<string, Terminal>
local lazygits = setmetatable({}, {
  __index = function(self, path)
    if type(path) ~= 'string' or not vim.uv.fs_stat(path) then return nil end
    local lazygit = terminal.Terminal:new {
      count = 1000 + num_lazygits,
      cmd = 'lazygit',
      dir = path,
      direction = 'float',
      hidden = true,
      on_open = function()
        vim.cmd 'silent! normal! 0'
        vim.cmd 'silent! startinsert!'
      end,
    }
    self[path] = lazygit
    num_lazygits = num_lazygits + 1
    return lazygit
  end,
})

---Toggle lazygit
---@param dir string?
local function lazygit_toggle(dir)
  dir = vim.fs.normalize(dir or vim.fn.getcwd())
  local git_repo = vim.system({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' }):wait().stdout:gsub('\n.*', '')
  if lazygits[git_repo] then
    lazygits[git_repo]:toggle()
    if lazygits[git_repo]:is_open() then last_visited_git_repo = git_repo end
  elseif last_visited_git_repo and lazygits[last_visited_git_repo] then
    lazygits[last_visited_git_repo]:toggle()
  else
    vim.notify('[lazygit] not inside git repo', vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command('Lazygit', function(info) lazygit_toggle(info.fargs[1]) end, {
  nargs = '?',
  complete = function(arglead)
    local existing_paths = vim.tbl_keys(lazygits)
    return vim.tbl_isempty(existing_paths) and vim.fn.getcompletion(arglead, 'dir') or existing_paths
  end,
})
