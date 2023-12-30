local git = require 'utils.git'

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  local lazy_path = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

  if not vim.uv.fs_stat(lazy_path) then
    local url = 'https://github.com/folke/lazy.nvim.git'
    vim.notify('[plugins] installing lazy.nvim...', vim.log.levels.INFO)
    if
      not git.execute({
        'clone',
        '--filter=blob:none',
        url,
        lazy_path,
      }, vim.log.levels.INFO).success
    then
      return false
    else
      vim.notify(
        '[plugins] lazy.nvim cloned to ' .. lazy_path,
        vim.log.levels.INFO
      )
    end
  end

  vim.opt.rtp:prepend(vim.env.LAZY or lazy_path)
  return true
end

---Setup Lazy
---@param spec LazySpec
local function setup_lazy(spec)
  local config = {
    spec = spec,
    defaults = { lazy = true, version = false },
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
        list = { vim.trim(PREF.icons.ui.Circle) },
      },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { 'catppuccin-mocha' } },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }

  require('lazy').setup(config)
end

if vim.env.NVIM_MANPAGER or not bootstrap() then return end
if vim.g.vscode then
  setup_lazy {
    { import = 'plugins.lib' },
    { import = 'plugins.editing' },
    { import = 'plugins.treesitter' },
    { import = 'plugins.extra.lang.c' },
    { import = 'plugins.extra.lang.markdown' },
    { import = 'plugins.extra.lang.typescript' },
  }
else
  setup_lazy {
    { import = 'plugins' },
    { import = 'plugins.extra.lang.c' },
    { import = 'plugins.extra.lang.markdown' },
    { import = 'plugins.extra.lang.typescript' },
  }
end
