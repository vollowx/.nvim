local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    if autocmd[2].group and vim.fn.exists('#' .. autocmd[2].group) == 0 then
      vim.api.nvim_create_augroup(autocmd[2].group, { clear = true })
    end
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  -- Highlight the selection on yank
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      group = 'YankHighlight',
      callback = function()
        vim.highlight.on_yank { higroup = 'Visual', timeout = 300 }
      end,
    },
  },

  -- Append system clipboard to clipboard settings here because setting it on
  -- startup dramatically slows down startup time
  {
    { 'TextYankPost' },
    {
      group = 'YankToSystemClipboard',
      once = true,
      callback = function()
        vim.opt.clipboard:append 'unnamedplus'
        vim.cmd('silent! let @+ = @' .. vim.v.register)
        return true
      end,
    },
  },

  {
    { 'BufReadPost' },
    {
      pattern = '*',
      group = 'LastPosJmp',
      desc = 'Last position jump.',
      callback = function(info)
        local ft = vim.bo[info.buf].ft
        -- don't apply to git messages
        if ft ~= 'gitcommit' and ft ~= 'gitrebase' then
          vim.cmd 'silent! normal! g`"'
        end
      end,
    },
  },

  {
    { 'BufReadPost', 'BufWinEnter', 'FileChangedShellPost' },
    {
      pattern = '*',
      group = 'AutoCwd',
      desc = 'Automatically change local current directory.',
      callback = function(info)
        if info.file == '' or not vim.bo[info.buf].ma then return end
        local current_dir = vim.fn.getcwd()
        local proj_dir = require('utils').fs.proj_dir(info.file)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if current_dir == proj_dir then return end
        if proj_dir then
          vim.cmd.lcd(proj_dir)
          return
        end
        local dirname = vim.fs.dirname(info.file)
        local stat = vim.uv.fs_stat(dirname)
        if stat and stat.type == 'directory' and proj_dir ~= current_dir then
          vim.cmd.lcd(dirname)
        end
      end,
    },
  },

  {
    { 'BufReadPre', 'UIEnter' },
    {
      group = 'RestoreBackground',
      once = true,
      desc = 'Restore dark/light background and colorscheme from ShaDa.',
      callback = function()
        if vim.g.theme_restored then return end
        vim.g.theme_restored = true
        if vim.g.BACKGROUND and vim.g.BACKGROUND ~= vim.go.background then
          vim.go.background = vim.g.BACKGROUND
        end
        if not vim.g.colors_name or vim.g.COLORSNAME ~= vim.g.colors_name then
          vim.cmd('silent! colorscheme ' .. (vim.g.COLORSNAME or 'catppuccin'))
        end
        return true
      end,
    },
  },

  {
    { 'Signal' },
    {
      nested = true,
      pattern = 'SIGUSR1',
      group = 'SwitchBackground',
      desc = 'Change background on receiving signal SIGUSER1.',
      callback = function()
        local hrtime = vim.uv.hrtime()
        -- Check the last time when a signal is received/sent to avoid
        -- the infinite loop of
        -- -> receiving signal
        -- -> setting bg
        -- -> sending signals to other nvim instances
        -- -> receiving signals from other nvim instances
        -- -> setting bg
        -- -> ...
        if vim.g.sig_hrtime and hrtime - vim.g.sig_hrtime < 500000000 then
          return
        end
        vim.g.sig_hrtime = hrtime
        vim.cmd.rshada()
        -- Must save the background and colorscheme name read from ShaDa
        -- because setting background or colorscheme will overwrite them
        local background = vim.g.BACKGROUND or 'dark'
        local colors_name = vim.g.COLORSNAME or 'catppuccin'
        if vim.go.background ~= background then
          vim.go.background = background
        end
        if vim.g.colors_name ~= colors_name then
          vim.cmd('silent! colorscheme ' .. colors_name)
        end
      end,
    },
  },
  {
    { 'Colorscheme' },
    {
      group = 'SwitchBackground',
      desc = 'Spawn setbg/setcolors on colorscheme change.',
      callback = function()
        vim.g.BACKGROUND = vim.go.background
        vim.g.COLORSNAME = vim.g.colors_name
        vim.cmd.wshada()
        local hrtime = vim.uv.hrtime()
        if vim.g.sig_hrtime and hrtime - vim.g.sig_hrtime < 500000000 then
          return
        end
        vim.g.sig_hrtime = hrtime
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
    },
  },

  -- Terminal options
  {
    { 'TermOpen' },
    {
      group = 'TermOptions',
      callback = function(info)
        if vim.bo[info.buf].buftype == 'terminal' then
          vim.cmd.setlocal 'nonu'
          vim.cmd.setlocal 'nornu'
          vim.cmd.setlocal 'statuscolumn='
          vim.cmd.setlocal 'signcolumn=no'
          vim.cmd.startinsert()
        end
      end,
    },
  },

  -- Open quickfix window if there are results
  {
    { 'QuickFixCmdPost' },
    {
      group = 'QuickFixAutoOpen',
      callback = function(info)
        if vim.startswith(info.match, 'l') then
          vim.cmd 'lwindow'
        else
          vim.cmd 'botright cwindow'
        end
      end,
    },
  },

  {
    { 'BufWinEnter' },
    {
      group = 'UpdateFolds',
      desc = 'Update folds on BufEnter.',
      callback = function(info)
        if not vim.b[info.buf].foldupdated then
          vim.b[info.buf].foldupdated = true
          vim.cmd.normal { 'zx', bang = true }
        end
      end,
    },
  },
  {
    { 'BufUnload' },
    {
      group = 'UpdateFolds',
      callback = function(info) vim.b[info.buf].foldupdated = nil end,
    },
  },

  {
    { 'OptionSet' },
    {
      pattern = 'diff',
      group = 'DisableWinBarInDiffMode',
      desc = 'Disable winbar in diff mode.',
      callback = function()
        if vim.v.option_new == '1' then
          vim.w._winbar = vim.wo.winbar
          vim.wo.winbar = nil
          if vim.wo.culopt:find 'both' or vim.wo.culopt:find 'line' then
            vim.w._culopt = vim.wo.culopt
            vim.wo.culopt = 'number'
          end
        else
          if vim.w._winbar then
            vim.wo.winbar = vim.w._winbar
            vim.w._winbar = nil
          end
          if vim.w._culopt then
            vim.wo.culopt = vim.w._culopt
            vim.w._culopt = nil
          end
        end
      end,
    },
  },

  {
    { 'BufWritePre' },
    {
      group = 'UpdateTimestamp',
      desc = 'Update timestamp automatically.',
      callback = function(info)
        if not vim.bo[info.buf].ma or not vim.bo[info.buf].mod then
 return end
        local lines = vim.api.nvim_buf_get_lines(info.buf, 0, 8, false)
        local update = false
        for idx, line in ipairs(lines) do
          -- Example: "Fri 07 Jul 2023 12:04:05 AM CDT"
          local new_str, pos = line:gsub(
            '%u%U%U%s+%d%d%s+%u%U%U%s+%d%d%d%d%s+%d%d:%d%d:%d%d%s+%u%u%s+%u+',
            os.date '%a %d %b %Y %I:%M:%S %p %Z'
          )
          if pos > 0 then
            update = true
            lines[idx] = new_str
          end
        end
        if update then
          -- Only join further change with the previous undo block
          -- when the current undo block is a leaf node (no further change),
          -- see `:h undojoin` and `:h E790`
          local undotree = vim.fn.undotree(info.buf)
          if undotree.seq_cur == undotree.seq_last then
            vim.cmd.undojoin()
            vim.api.nvim_buf_set_lines(info.buf, 0, 8, false, lines)
          end
        end
      end,
    },
  },
}

set_autocmds(autocmds)
