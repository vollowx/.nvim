local utils = require 'utils'
local conf_path = vim.fn.stdpath 'config' --[[@as string]]
local data_path = vim.fn.stdpath 'data' --[[@as string]]
local state_path = vim.fn.stdpath 'state' --[[@as string]]

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  vim.g.package_path = vim.fs.joinpath(data_path, 'packages')
  vim.g.package_lock = vim.fs.joinpath(conf_path, 'package-lock.json')
  local lazy_path = vim.fs.joinpath(vim.g.package_path, 'lazy.nvim')
  if vim.uv.fs_stat(lazy_path) then
    vim.opt.rtp:prepend(lazy_path)
    return true
  end

  local startup_file = vim.fs.joinpath(state_path, 'startup.json')
  local startup_data = utils.json.read(startup_file)
  if startup_data.bootstrap == false then return false end

  local response = ''
  vim.ui.input({
    prompt = '[packages] package manager not found, bootstrap? [y/N/never] ',
  }, function(r) response = r end)

  if vim.fn.match(response, '[Nn][Ee][Vv][Ee][Rr]') >= 0 then
    startup_data.bootstrap = false
    utils.json.write(startup_file, startup_data)
    return false
  end

  if vim.fn.match(response, '^[Yy]\\([Ee][Ss]\\)\\?$') < 0 then return false end

  print '\n'
  local lock_data = utils.json.read(vim.g.package_lock)
  local commit = lock_data['lazy.nvim'] and lock_data['lazy.nvim'].commit
  local url = 'https://github.com/folke/lazy.nvim.git'
  vim.notify '[packages] installing lazy.nvim...'
  vim.fn.mkdir(vim.g.package_path, 'p')
  if
    not utils.git.execute({
      'clone',
      '--filter=blob:none',
      url,
      lazy_path,
    }, vim.log.levels.INFO).success
  then
    return false
  end

  if commit then
    utils.git.dir_execute(
      lazy_path,
      { 'checkout', commit },
      vim.log.levels.INFO
    )
  end
  local lazy_patch_path =
    vim.fs.joinpath(conf_path, 'patches', 'lazy.nvim.patch')
  if vim.uv.fs_stat(lazy_patch_path) and vim.uv.fs_stat(lazy_path) then
    utils.git.dir_execute(lazy_path, {
      'apply',
      '--ignore-space-change',
      lazy_patch_path,
    }, vim.log.levels.WARN)
  end
  vim.notify('[packages] lazy.nvim cloned to ' .. lazy_path)
  vim.opt.rtp:prepend(lazy_path)
  return true
end

---Enable modules
---@param module_names string[]
local function setup_lazy(module_names)
  local config = {
    root = vim.g.package_path,
    lockfile = vim.g.package_lock,
    defaults = { lazy = true },
    ui = {
      border = PREF.ui.border,
      size = { width = 0.7, height = 0.74 },
      icons = {
        cmd = vim.trim(PREF.icons.ui.Command),
        config = vim.trim(PREF.icons.kinds.Constructor),
        event = vim.trim(PREF.icons.kinds.Event),
        ft = vim.trim(PREF.icons.kinds.File),
        init = vim.trim(PREF.icons.ui.Flag),
        import = vim.trim(PREF.icons.ui.Import),
        keys = vim.trim(PREF.icons.ui.Keyboard),
        lazy = PREF.icons.ui.Sleep .. ' ',
        loaded = vim.trim(PREF.icons.diagnostics.Ok),
        not_loaded = vim.trim(PREF.icons.ui.Ghost),
        plugin = vim.trim(PREF.icons.kinds.Package),
        runtime = vim.trim(PREF.icons.ui.TimerPlay),
        source = vim.trim(PREF.icons.ui.Code),
        start = vim.trim(PREF.icons.ui.TriangleRight),
        task = vim.trim(PREF.icons.diagnostics.Ok),
        list = { '' },
      },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { 'catppuccin-mocha' } },
    performance = {
      rtp = {
        disabled_plugins = {},
      },
    },
  }
  local modules = {}
  for _, module_name in ipairs(module_names) do
    vim.list_extend(modules, require('packages.' .. module_name))
  end
  require('lazy').setup(modules, config)
end

if not bootstrap() then return end

if vim.g.vscode then
  setup_lazy {
    'lib',
    'editing',
    'treesitter',
    'extra.lang.c',
    'extra.lang.markdown',
    'extra.lang.typescript',
  }
else
  setup_lazy {
    'lib',
    'lsp',
    'editing',
    'tools',
    'completion',
    'treesitter',
    'colorschemes',
    'ui',
    'extra.lang.c',
    'extra.lang.markdown',
    'extra.lang.typescript',
  }
end
