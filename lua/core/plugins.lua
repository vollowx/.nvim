local git = require 'utils.git'
local icons = require('utils.static').icons

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

---Load custom events
local function setup_file_event()
  local Event = require 'lazy.core.handler.event'

  Event.mappings.LazyFile =
    { id = 'LazyFile', event = 'User', pattern = 'LazyFile' }

  local events = {} ---@type {event: string, buf: number, data?: any}[]

  local done = false
  local function load()
    if #events == 0 or done then return end
    done = true
    vim.api.nvim_del_augroup_by_name 'lazy_file'

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds(
      'User',
      { pattern = 'LazyFile', modeline = false }
    )
    for _, event in ipairs(events) do
      if vim.api.nvim_buf_is_valid(event.buf) then
        Event.trigger {
          event = event.event,
          exclude = skips[event.event],
          data = event.data,
          buf = event.buf,
        }
        if vim.bo[event.buf].filetype then
          Event.trigger {
            event = 'FileType',
            buf = event.buf,
          }
        end
      end
    end
    vim.api.nvim_exec_autocmds('CursorMoved', { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
    group = vim.api.nvim_create_augroup('lazy_file', { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

---Setup Lazy
---@param spec LazySpec
local function setup_lazy(spec)
  setup_file_event()

  local config = {
    spec = spec,
    defaults = { lazy = true, version = false },
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
        lazy = icons.ui.Sleep .. ' ',
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
    install = { colorscheme = { 'catppuccin-mocha' } },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
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
