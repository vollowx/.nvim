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
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
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
        vim.opt.clipboard:append('unnamedplus')
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
        if info.file == '' or not vim.bo[info.buf].ma then
          return
        end
        local proj_dir = require('utils').fs.proj_dir(info.file)
        if proj_dir then
          vim.cmd.lcd(proj_dir)
        else
          local dirname = vim.fs.dirname(info.file)
          local stat = vim.uv.fs_stat(dirname)
          if stat and stat.type == 'directory' then
            vim.cmd.lcd(dirname)
          end
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
          vim.cmd.setlocal('nonu')
          vim.cmd.setlocal('nornu')
          vim.cmd.setlocal('statuscolumn=')
          vim.cmd.setlocal('signcolumn=no')
          vim.cmd.startinsert()
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

  {
    { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
    {
      desc = 'User events for file detection (NvFile and NvGitFile)',
      group = 'FileUserEvents',
      callback = function(args)
        if not (vim.fn.expand '%' == '' or vim.api.nvim_get_option_value('buftype', { buf = args.buf }) == 'nofile') then
          release_event 'File'
          if
            require('utils').git.file_worktree()
            or require('utils').command.cmd({ 'git', '-C', vim.fn.expand '%:p:h', 'rev-parse' }, false)
          then
            release_event 'GitFile'
            vim.api.nvim_del_augroup_by_name 'FileUserEvents'
          end
        end
      end,
    },
  },
}

set_autocmds(autocmds)
