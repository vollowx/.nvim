local release_event = require('utils').event.release

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
      callback = function() vim.highlight.on_yank { higroup = 'Visual', timeout = 300 } end,
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

  -- Jump to last accessed window on closing the current one
  {
    { 'WinEnter' },
    {
      pattern = '*',
      group = 'WinCloseJmp',
      callback = function()
        if '' ~= vim.api.nvim_win_get_config(0).relative then
          return
        end
        -- Record the window we jump from (previous) and to (current)
        if nil == vim.t.winid_rec then
          vim.t.winid_rec = {
            prev = vim.fn.win_getid(),
            current = vim.fn.win_getid(),
          }
        else
          vim.t.winid_rec = {
            prev = vim.t.winid_rec.current,
            current = vim.fn.win_getid(),
          }
        end
        -- Loop through all windows to check if the
        -- previous one has been closed
        for winnr = 1, vim.fn.winnr('$') do
          if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
            return -- Return if previous window is not closed
          end
        end
        vim.cmd('wincmd p')
      end,
    },
  },

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      group = 'LastPosJmp',
      callback = function(info)
        local ft = vim.bo[info.buf].ft
        -- don't apply to git messages
        if ft:match('commit') or ft:match('rebase') then
          return
        end
        -- get position of last saved edit
        local markpos = vim.api.nvim_buf_get_mark(0, '"')
        local line = markpos[1]
        local col = markpos[2]
        -- if in range, go there
        if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
          vim.api.nvim_win_set_cursor(0, { line, col })
          vim.cmd.normal({ 'zvzz', bang = true })
        end
      end,
    },
  },

  -- Automatically change local current directory
  {
    { 'BufReadPost', 'BufWinEnter', 'FileChangedShellPost' },
    {
      pattern = '*',
      group = 'AutoCwd',
      callback = function(info)
        if info.file == '' or not vim.bo[info.buf].ma then return end
        local proj_dir = require('utils').fs.proj_dir(info.file)
        if proj_dir then
          vim.cmd.lcd(proj_dir)
        else
          local dirname = vim.fs.dirname(info.file)
          local stat = vim.uv.fs_stat(dirname)
          if stat and stat.type == 'directory' then vim.cmd.lcd(dirname) end
        end
      end,
    },
  },

  -- Restore dark/light background and colorscheme from ShaDa
  {
    { 'BufReadPre', 'UIEnter' },
    {
      group = 'RestoreBackground',
      once = true,
      callback = function()
        if vim.g.theme_restored then
          return
        end
        vim.g.theme_restored = true
        if vim.g.BACKGROUND and vim.g.BACKGROUND ~= vim.go.background then
          vim.go.background = vim.g.BACKGROUND
        end
        if not vim.g.colors_name or vim.g.COLORSNAME ~= vim.g.colors_name then
          vim.cmd('silent! colorscheme ' .. (vim.g.COLORSNAME or 'catppuccin-mocha'))
        end
        return true
      end,
    },
  },

  -- Change background on receiving signal SIGUSER1
  {
    { 'Signal' },
    {
      nested = true,
      pattern = 'SIGUSR1',
      group = 'SwitchBackground',
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
        local colors_name = vim.g.COLORSNAME or 'catppuccin-mocha'
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
        if vim.fn.executable('setbg') == 1 then
          vim.uv.spawn('setbg', {
            args = {
              vim.go.background,
              '--exclude-nvim-processes=' .. pid,
            },
            stdio = { nil, nil, nil },
          })
        end
        if vim.fn.executable('setcolors') == 1 then
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

  -- Make window equal size on VimResized
  {
    { 'VimResized' },
    {
      group = 'EqualWinSize',
      command = 'wincmd =',
    },
  },

  -- Show cursor line and cursor column only in current window
  {
    { 'WinEnter' },
    {
      once = true,
      group = 'AutoHlCursorLine',
      desc = 'Initialize cursorline winhl.',
      callback = function()
        local winlist = vim.api.nvim_list_wins()
        for _, win in ipairs(winlist) do
          vim.api.nvim_win_call(
            win,
            function()
              vim.opt_local.winhl:append {
                CursorLine = '',
                CursorColumn = '',
              }
            end
          )
        end
        return true
      end,
    },
  },
  {
    { 'BufWinEnter', 'WinEnter', 'InsertLeave' },
    {
      group = 'AutoHlCursorLine',
      callback = function()
        vim.defer_fn(function()
          if vim.fn.win_gettype() ~= '' then return end
          local winhl = vim.opt_local.winhl:get()
          -- Restore CursorLine and CursorColumn for current window
          -- if not in inert/replace/select mode
          if (winhl['CursorLine'] or winhl['CursorColumn']) and vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1 then
            vim.opt_local.winhl:remove {
              'CursorLine',
              'CursorColumn',
            }
          end
          -- Conceal cursor line and cursor column in the previous window
          -- if current window is a normal window
          local current_win = vim.api.nvim_get_current_win()
          local prev_win = vim.fn.win_getid(vim.fn.winnr '#')
          if
            prev_win ~= 0
            and prev_win ~= current_win
            and vim.api.nvim_win_is_valid(prev_win)
            and vim.fn.win_gettype(current_win) == ''
          then
            vim.api.nvim_win_call(
              prev_win,
              function()
                vim.opt_local.winhl:append {
                  CursorLine = '',
                  CursorColumn = '',
                }
              end
            )
          end
        end, 10)
      end,
    },
  },
  {
    { 'InsertEnter' },
    {
      group = 'AutoHlCursorLine',
      callback = function()
        vim.opt_local.winhl:append {
          CursorLine = '',
          CursorColumn = '',
        }
      end,
    },
  },

  -- Update folds on BufEnter
  {
    { 'BufWinEnter', 'BufEnter' },
    {
      group = 'UpdateFolds',
      callback = function(info)
        if not vim.b[info.buf].foldupdated then
          vim.b[info.buf].foldupdated = true
          vim.cmd.normal 'zx'
        end
      end,
    },
  },

  -- Disable winbar in diff mode
  {
    { 'OptionSet' },
    {
      pattern = 'diff',
      group = 'DisableWinBarInDiffMode',
      callback = function()
        if vim.v.option_new == '1' then
          vim.w._winbar = vim.wo.winbar
          vim.wo.winbar = nil
        else
          vim.wo.winbar = vim.w._winbar
        end
      end,
    },
  },

  -- Automatically clear message area on specific events
  {
    { 'ModeChanged', 'WinLeave', 'BufLeave', 'FocusLost' },
    {
      group = 'ClearMsgArea',
      command = 'echo',
    },
  },

  -- Update timestamp automatically
  {
    { 'BufWritePre' },
    {
      group = 'UpdateTimestamp',
      callback = function(info)
        if not vim.bo[info.buf].ma or not vim.bo[info.buf].mod then return end
        -- Example: "Fri 07 Jul 2023 12:04:05 AM CDT"
        local timestamp_pattern = '%u%U%U%s+%d%d%s+%u%U%U%s+%d%d%d%d%s+%d%d:%d%d:%d%d%s+%u%u%s+%u+'
        local lines = vim.api.nvim_buf_get_lines(info.buf, 0, 8, false)
        local update = false
        for idx, line in ipairs(lines) do
          local new_str, pos = line:gsub(timestamp_pattern, os.date())
          if pos > 0 then
            update = true
            lines[idx] = new_str
          end
        end
        if update then vim.api.nvim_buf_set_lines(info.buf, 0, 8, false, lines) end
      end,
    },
  },

  -- File detection (File and GitFile) for lazy.nvim
  {
    { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
    {
      group = 'FileEvents',
      callback = function(args)
        if
          not (vim.fn.expand '%' == '' or vim.api.nvim_get_option_value('buftype', { buf = args.buf }) == 'nofile')
        then
          release_event 'File'
          if
            require('utils').git.file_worktree()
            or require('utils').command.cmd({ 'git', '-C', vim.fn.expand '%:p:h', 'rev-parse' }, false)
          then
            release_event 'GitFile'
            vim.api.nvim_del_augroup_by_name 'FileEvents'
          end
        end
      end,
    },
  },
}

set_autocmds(autocmds)
