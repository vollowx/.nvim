---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
local function au(group, ...)
  local groupid = vim.api.nvim_create_augroup(group, {})
  for _, autocmd in ipairs { ... } do
    autocmd[2].group = groupid
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

au('LargeFileSettings', {
  'BufReadPre',
  {
    desc = 'Set settings for large files.',
    callback = function(info)
      if vim.b.large_file ~= nil then return end
      vim.b.large_file = false
      local stat = vim.uv.fs_stat(info.match)
      if stat and stat.size > 1000000 then
        vim.b.large_file = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.winbar = ''
        vim.api.nvim_create_autocmd('BufReadPost', {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.opt_local.syntax = ''
            vim.opt_local.filetype = ''
            return true
          end,
        })
      end
    end,
  },
})

au('YankHighlight', {
  'TextYankPost',
  {
    group = 'YankHighlight',
    desc = 'Highlight the selection on yank.',
    callback = function()
      vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
    end,
  },
})

au('Autosave', {
  { 'BufLeave', 'WinLeave', 'FocusLost' },
  {
    nested = true,
    group = 'Autosave',
    desc = 'Autosave on focus change.',
    command = 'if &bt ==# "" | silent! update | endif',
  },
})

au('WinCloseJmp', {
  'WinClosed',
  {
    nested = true,
    desc = 'Jump to last accessed window on closing the current one.',
    command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
  },
})

au('LastPosJmp', {
  'BufReadPost',
  {
    desc = 'Last position jump.',
    callback = function(info)
      local ft = vim.bo[info.buf].ft
      -- don't apply to git messages
      if ft ~= 'gitcommit' and ft ~= 'gitrebase' then
        vim.cmd 'silent! normal! g`"'
      end
    end,
  },
})

au('AutoCwd', {
  { 'BufWinEnter', 'FileChangedShellPost' },
  {
    pattern = '*',
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
        local current_dir = vim.fn.getcwd(0)
        local proj_dir = require('utils').fs.proj_dir(info.file)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if current_dir == proj_dir then return end
        if proj_dir then
          vim.cmd.lcd(proj_dir)
          return
        end
        local dirname = vim.fs.dirname(info.file) --[[@as string]]
        local stat = vim.uv.fs_stat(dirname)
        if stat and stat.type == 'directory' and proj_dir ~= current_dir then
          vim.cmd.lcd(dirname)
        end
      end)
    end,
  },
})

au('PromptBufKeymaps', {
  'BufEnter',
  {
    desc = 'Undo automatic <C-w> remap in prompt buffers.',
    callback = function(info)
      if vim.bo[info.buf].buftype == 'prompt' then
        vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
      end
    end,
  },
})

au('QuickFixAutoOpen', {
  'QuickFixCmdPost',
  {
    desc = 'Open quickfix window if there are results.',
    callback = function(info)
      if #vim.fn.getqflist() <= 1 then return end
      if vim.startswith(info.match, 'l') then
        vim.schedule(function() vim.cmd 'bel lwindow' end)
      else
        vim.schedule(function() vim.cmd 'bot cwindow' end)
      end
    end,
  },
})

au('EqualWinSize', {
  'VimResized',
  {
    desc = 'Make window equal size on VimResized.',
    command = 'wincmd =',
  },
})

-- Show cursor line and cursor column only in current window
au('AutoHlCursorLine', {
  'WinEnter',
  {
    once = true,
    desc = 'Initialize cursorline winhl.',
    callback = function()
      local winlist = vim.api.nvim_list_wins()
      for _, win in ipairs(winlist) do
        vim.api.nvim_win_call(
          win,
          function()
            vim.opt_local.winhl:append { CursorLine = '', CursorColumn = '' }
          end
        )
      end
      return true
    end,
  },
}, {
  { 'BufWinEnter', 'WinEnter', 'InsertLeave' },
  {
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
}, {
  'InsertEnter',
  {
    callback = function()
      vim.opt_local.winhl:append { CursorLine = '', CursorColumn = '' }
    end,
  },
})

au('UpdateFolds', {
  'BufWinEnter',
  {
    desc = 'Update folds on BufEnter.',
    callback = function(info)
      if not vim.b[info.buf].foldupdated then
        vim.b[info.buf].foldupdated = true
        vim.cmd.normal { 'zx', bang = true }
      end
    end,
  },
}, {
  'BufUnload',
  {
    callback = function(info) vim.b[info.buf].foldupdated = nil end,
  },
})

au('TextwidthRelativeColorcolumn', {
  'OptionSet',
  {
    pattern = 'textwidth',
    desc = 'Set colorcolumn according to textwidth.',
    callback = function()
      if vim.v.option_new ~= 0 then vim.opt_local.colorcolumn = '+1' end
    end,
  },
})

au('DisableWinBarInDiffMode', {
  'OptionSet',
  {
    pattern = 'diff',
    desc = 'Disable winbar in diff mode.',
    callback = function()
      if vim.v.option_new then
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
})

au('UpdateTimestamp', {
  'BufWritePre',
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
})

au('FixVirtualEditCursorPos', {
  'CursorMoved',
  {
    desc = 'Record cursor position in visual mode if virtualedit is set.',
    callback = function()
      if vim.wo.ve:find 'all' then vim.w.ve_cursor = vim.fn.getcurpos() end
    end,
  },
})

au('FixVirtualEditCursorPos', {
  'ModeChanged',
  {
    desc = 'Keep cursor position after entering normal mode from visual mode with virtual edit enabled.',
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
})
