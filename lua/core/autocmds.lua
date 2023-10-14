local autocmds = {
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      group = 'YankHighlight',
      desc = 'Highlight the selection on yank.',
      callback = function()
        vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
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
      desc = 'Yank into system clipboard.',
      callback = function()
        vim.opt.clipboard:append 'unnamedplus'
        vim.cmd('silent! let @+ = @' .. vim.v.register)
        return true
      end,
    },
  },

  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      pattern = '*',
      group = 'Autosave',
      desc = 'Autosave on focus change.',
      command = 'silent! wall',
      nested = true,
    },
  },

  {
    { 'WinClosed' },
    {
      pattern = '*',
      nested = true,
      group = 'WinCloseJmp',
      desc = 'Jump to last accessed window on closing the current one.',
      command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
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
        vim.schedule(function()
          if
            info.file == ''
            or not vim.api.nvim_buf_is_valid(info.buf)
            or not vim.bo[info.buf].ma
          then
            return
          end
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
        end)
      end,
    },
  },

  {
    { 'BufEnter' },
    {
      group = 'PromptBufKeymaps',
      desc = 'Undo automatic <C-w> remap in prompt buffers.',
      callback = function(info)
        if vim.bo[info.buf].buftype == 'prompt' then
          vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
        end
      end,
    },
  },

  {
    { 'VimResized' },
    {
      group = 'EqualWinSize',
      desc = 'Make window equal size on VimResized.',
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
          if
            (winhl['CursorLine'] or winhl['CursorColumn'])
            and vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1
          then
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
      pattern = 'textwidth',
      group = 'TextwidthRelativeColorcolumn',
      desc = 'Set colorcolumn according to textwidth.',
      callback = function()
        if vim.v.option_new ~= '0' then vim.opt_local.colorcolumn = '+1' end
      end,
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
        if not vim.bo[info.buf].ma or not vim.bo[info.buf].mod then return end
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

  {
    { 'CursorMoved' },
    {
      desc = 'Record cursor position in visual mode if virtualedit is set.',
      group = 'FixVirtualEditCursorPos',
      callback = function()
        if vim.wo.ve:find 'all' then vim.w.ve_cursor = vim.fn.getcurpos() end
      end,
    },
  },
  {
    { 'ModeChanged' },
    {
      desc = 'Keep cursor position after entering normal mode from visual mode with virtual edit enabled.',
      group = 'FixVirtualEditCursorPos',
      pattern = '[vV\x16]*:n',
      callback = function()
        if vim.wo.ve:find 'all' and vim.w.ve_cursor then
          vim.api.nvim_win_set_cursor(0, {
            vim.w.ve_cursor[2],
            vim.w.ve_cursor[3] + vim.w.ve_cursor[4] - 1,
          })
        end
      end,
    },
  },
}

if not vim.g.loaded_autocmds then
  for _, au in ipairs(autocmds) do
    local audef = au[2]
    if audef.group and vim.fn.exists('#' .. audef.group) == 0 then
      vim.api.nvim_create_augroup(audef.group, {})
    end
    vim.api.nvim_create_autocmd(unpack(au))
  end
  vim.g.loaded_autocmds = true
end
