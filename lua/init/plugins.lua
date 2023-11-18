local git = require 'utils.git'
local icons = require('utils.static').icons

local confpath = vim.fn.stdpath 'config'
local datapath = vim.fn.stdpath 'data'

---Read file contents
---@param path string
---@return string?
local function read_file(path)
  local file = io.open(path, 'r')
  if not file then return nil end
  local content = file:read '*a'
  file:close()
  return content
end

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  vim.g.package_path = datapath .. '/lazy'
  vim.g.package_lock = confpath .. '/lazy-lock.json'
  local lazy_path = vim.g.package_path .. '/lazy.nvim'
  vim.opt.rtp:prepend(lazy_path)
  vim.opt.pp:prepend(lazy_path)
  if vim.uv.fs_stat(lazy_path) then return true end

  local lock = read_file(vim.g.package_lock)
  local lock_data = lock and vim.json.decode(lock) or nil
  local commit = lock_data
      and lock_data['lazy.nvim']
      and lock_data['lazy.nvim'].commit
    or nil
  local url = 'https://github.com/folke/lazy.nvim.git'
  vim.notify('[plugins] installing lazy.nvim...', vim.log.levels.INFO)
  vim.fn.mkdir(vim.g.package_path, 'p')
  if
    not git.execute({
      'clone',
      '--filter=blob:none',
      url,
      lazy_path,
    }, vim.log.levels.INFO).success
  then
    return false
  end
  if commit then
    git.dir_execute(lazy_path, { 'checkout', commit }, vim.log.levels.INFO)
  end
  vim.notify('[plugins] lazy.nvim cloned to ' .. lazy_path, vim.log.levels.INFO)
  return true
end

---Enable modules
---@param module_names string[]
local function enable_modules(module_names)
  local config = {
    defaults = { lazy = true },
    root = vim.g.plugin_path,
    lockfile = vim.g.plugin_lock,
    ui = {
      border = 'shadow',
      size = { width = 0.7, height = 0.74 },
      icons = {
        cmd = vim.trim(icons.ui.Command),
        config = vim.trim(icons.ui.Cog),
        event = vim.trim(icons.kinds.Event),
        ft = vim.trim(icons.kinds.File),
        init = vim.trim(icons.ui.Flag),
        import = vim.trim(icons.ui.Import),
        keys = vim.trim(icons.ui.Keyboard),
        lazy = icons.ui.Sleep,
        loaded = vim.trim(icons.ui.CheckCircle),
        not_loaded = vim.trim(icons.ui.Ghost),
        plugin = vim.trim(icons.kinds.Package),
        runtime = vim.trim(icons.ui.TimerPlay),
        source = vim.trim(icons.ui.Code),
        start = vim.trim(icons.ui.TriangleRight),
        task = icons.ui.CheckList,
        list = {
          icons.ui.Circle,
          icons.ui.CircleUnfilled,
          icons.ui.TriangleRight,
          icons.ui.Square,
        },
      },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { 'catppuccin' } },
    performance = { rtp = { disabled_plugins = {} } },
  }
  local modules = {}
  for _, module_name in ipairs(module_names) do
    vim.list_extend(modules, require('modules.' .. module_name))
  end
  require('lazy').setup(modules, config)
end

if vim.env.NVIM_MANPAGER or not bootstrap() then return end
require('utils.plugins').setup()
if vim.g.vscode then
  enable_modules {
    'lib',
    'treesitter',
    'edit',
  }
else
  enable_modules {
    'lib',
    'completion',
    'edit',
    'lsp',
    'markup',
    'tools',
    'treesitter',
    'ui',
    'colorscheme',
  }
end
