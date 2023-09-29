-- 1. Restore dark/light background and colorscheme from ShaDa so that nvim
--    "remembers" the background and colorscheme when it is restarted.
-- 2. Change background on receiving signal SIGUSER1 to make nvim colorscheme
--    consistent with the system background.
--    - The signal is sent by setbg/setcolors scripts when the background or
--      colorscheme is changed by the user.
-- 3. Spawn setbg/setcolors on colorscheme change to make other nvim instances
--    and system color consistent with the current nvim instance.

local groupid = vim.api.nvim_create_augroup('SwitchBackground', {})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'UIEnter' }, {
  once = true,
  group = groupid,
  desc = 'Restore dark/light background and colorscheme from ShaDa.',
  callback = function()
    if vim.g.theme_restored then return end

    vim.g.theme_restored = true
    if vim.g.BACKGROUND and vim.g.BACKGROUND ~= vim.go.background then
      vim.go.background = vim.g.BACKGROUND
    end
    if not vim.g.colors_name or vim.g.COLORSNAME ~= vim.g.colors_name then
      vim.cmd(
        'silent! colorscheme ' .. (vim.g.COLORSNAME or 'catppuccin-mocha')
      )
    end
    return true
  end,
})

vim.api.nvim_create_autocmd('Signal', {
  nested = true,
  pattern = 'SIGUSR1',
  group = groupid,

  desc = 'Change background on receiving signal SIGUSER1.',
  callback = function()
    local now = vim.uv.now()
    -- Check the last time when a signal is received/sent to avoid
    -- the infinite loop of
    -- -> receiving signal
    -- -> setting bg
    -- -> sending signals to other nvim instances
    -- -> receiving signals from other nvim instances
    -- -> setting bg
    -- -> ...
    if vim.g.sigtime and now - vim.g.sigtime < 500 then return end

    vim.g.sigtime = now
    vim.cmd.rshada()
    -- Must save the background and colorscheme name read from ShaDa
    -- because setting background or colorscheme will overwrite them
    local background = vim.g.BACKGROUND or 'dark'
    local colors_name = vim.g.COLORSNAME or 'catppuccin-mocha'
    if vim.go.background ~= background then vim.go.background = background end
    if vim.g.colors_name ~= colors_name then
      vim.cmd('silent! colorscheme ' .. colors_name)
    end
  end,
})

vim.api.nvim_create_autocmd('Colorscheme', {
  group = 'SwitchBackground',
  desc = 'Spawn setbg/setcolors on colorscheme change.',
  callback = function()
    vim.g.BACKGROUND = vim.go.background
    vim.g.COLORSNAME = vim.g.colors_name
    vim.cmd.wshada()
    local now = vim.uv.now()
    if vim.g.sigtime and now - vim.g.sigtime < 500 then return end
    vim.g.sigtime = now
    local pid = vim.fn.getpid()
    if vim.fn.executable 'setbg' == 1 then
      vim.uv.spawn('setbg', {
        args = {
          vim.go.background,
          '--exclude-nvim-processes=' .. pid,
        },
        stdio = { nil, nil, nil },
      })
    end
    if vim.fn.executable 'setcolors' == 1 then
      vim.uv.spawn('setcolors', {
        args = {
          vim.g.colors_name,
          '--exclude-nvim-processes=' .. pid,
        },
        stdio = { nil, nil, nil },
      })
    end
  end,
})
