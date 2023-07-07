local settings = require('core.settings')
local use_ssh = settings.use_ssh
local utils = require('utils')

---Read file contents
---@param path string
---@return string?
local function read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*a')
  file:close()
  return content
end

-- Apply and restore local patches on plugin update/install
local function create_autocmd_applypatch()
  vim.api.nvim_create_autocmd('User', {
    pattern = { 'LazyInstall*', 'LazyUpdate*' },
    group = vim.api.nvim_create_augroup('LazyPatches', {}),
    callback = function(info)
      local patches_path = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua/plugins/patches')
      for patch in vim.fs.dir(patches_path) do
        local patch_path = vim.fs.joinpath(patches_path, patch)
        local plugin_path =
          vim.fs.joinpath(vim.g.package_path, (patch:gsub('%.patch$', '')))
        if vim.uv.fs_stat(plugin_path) then
          if
            info.match:match('Pre$')
            and utils.git.dir_execute(
                plugin_path,
                { 'diff', '--stat' },
                vim.log.levels.WARN
              ).output
              ~= ''
          then
            vim.notify('[plugins] reverting patch' .. patch_path)
            utils.git.dir_execute(plugin_path, {
              'apply',
              '--reverse',
              '--ignore-space-change',
              patch_path,
            }, vim.log.levels.WARN)
          else
            vim.notify('[plugins] applying patch' .. patch_path)
            utils.git.dir_execute(plugin_path, {
              'apply',
              '--ignore-space-change',
              patch_path,
            }, vim.log.levels.WARN)
          end
        end
      end
    end,
    desc = 'Reverse/Apply local patches on updating/intalling plugins.',
  })
end

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  create_autocmd_applypatch()
  vim.g.package_path = vim.fn.stdpath('data') .. '/site/pack/packages/opt'
  vim.g.package_lock = vim.fn.stdpath('config') .. '/lazy-lock.json'
  local lazy_path = vim.g.package_path .. '/lazy.nvim'
  vim.opt.rtp:prepend(lazy_path)
  vim.opt.pp:prepend(lazy_path)
  if vim.uv.fs_stat(lazy_path) then
    return true
  end

  local lock = read_file(vim.g.package_lock)
  local lock_data = lock and vim.json.decode(lock) or nil
  local commit = lock_data
      and lock_data['lazy.nvim']
      and lock_data['lazy.nvim'].commit
    or nil
  local url = use_ssh and 'git@github.com:folke/lazy.nvim.git' or 'https://github.com/folke/lazy.nvim.git'
  vim.notify('[plugins] installing lazy.nvim...', vim.log.levels.INFO)
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
  vim.notify(
    '[plugins] lazy.nvim cloned to ' .. lazy_path,
    vim.log.levels.INFO
  )
  return true
end

---Enable modules
---@param module_names string[]
local function enable_modules(module_names)
  local config = {
    root = vim.g.package_path,
    lockfile = vim.g.package_lock,
    git = {
      url_format = use_ssh and 'git@github.com:%s.git' or 'https://github.com/%s.git'
    },
    ui = {
      border = 'rounded',
      size = { width = 0.7, height = 0.74 },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { 'catppuccin' } },
    performance = {
      cache = {
        enabled = true,
        path = vim.fn.stdpath("cache") .. "/lazy/cache",
        -- Once one of the following events triggers, caching will be disabled.
        -- To cache all modules, set this to `{}`, but that is not recommended.
        disable_events = { "UIEnter", "BufReadPre" },
        ttl = 3600 * 24 * 2, -- keep unused modules for up to 2 days
      },
      reset_packpath = true,
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
          'health',
          'netrwPlugin',
        },
      },
    },
  }
  local modules = {}
  for _, module_name in ipairs(module_names) do
    vim.list_extend(modules, require('plugins.modules.' .. module_name))
  end
  require('lazy').setup(modules, config)
end

if vim.env.NVIM_MANPAGER or not bootstrap() then
  return
end
if vim.g.vscode then
  enable_modules({
    'base',
    'treesitter',
    'editor',
  })
else
  enable_modules({
    'base',
    -- 'completion',
    -- 'debug',
    'editor',
    -- 'lsp',
    -- 'markup',
    'tools',
    'treesitter',
    'ui',
  })
end
