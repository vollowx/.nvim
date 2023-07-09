local M = {}

---Print git command error
---@param cmd string[] shell command
---@param msg string error message
---@param lev number? log level to use for errors, defaults to WARN
---@return nil
function M.error(cmd, msg, lev)
  lev = lev or vim.log.levels.WARN
  vim.notify(
    '[git] failed to execute git command: '
      .. table.concat(cmd, ' ')
      .. '\n'
      .. msg,
    lev
  )
end

---Execute git command in given directory synchronously
---@param path string
---@param cmd string[] git command to execute
---@param error_lev number? log level to use for errors, hide errors if nil or false
---@reurn { success: boolean, output: string }
function M.dir_execute(path, cmd, error_lev)
  local shell_args = { 'git', '-C', path, unpack(cmd) }
  local shell_out = vim.fn.system(shell_args)
  if vim.v.shell_error ~= 0 then
    if error_lev then
      M.error(shell_args, shell_out, error_lev)
    end
    return {
      success = false,
      output = shell_out,
    }
  end
  return {
    success = true,
    output = shell_out,
  }
end

---Execute git command in current directory synchronously
---@param cmd string[] git command to execute
---@param error_lev number? log level to use for errors, hide errors if nil or false
---@reurn { success: boolean, output: string }
function M.execute(cmd, error_lev)
  local shell_args = { 'git', unpack(cmd) }
  local shell_out = vim.fn.system(shell_args)
  if vim.v.shell_error ~= 0 then
    if error_lev then
      M.error(shell_args, shell_out, error_lev)
    end
    return {
      success = false,
      output = shell_out,
    }
  end
  return {
    success = true,
    output = shell_out,
  }
end

---Store git branch names for each path
---@type table<string, string>
local path_branches = {}

---Get the current branch name asynchronously
---@param path string? defaults to the path to the current buffer
---@return string branch name
function M.branch(path)
  path = vim.fs.normalize(path or vim.api.nvim_buf_get_name(0))
  local dir = vim.fs.dirname(path)
  if dir then
    vim.system(
      { 'git', '-C', dir, 'rev-parse', '--abbrev-ref', 'HEAD' },
      { stderr = false },
      function(err, _)
        path_branches[dir] = err.stdout:gsub('\n.*', '')
      end
    )
  end
  return path_branches[dir] or ''
end

---Store git diff stats for each buffer
---@type table<string, {added: integer, removed: integer, changed: integer}>
local buf_diffstats = {}

---Get the diff stats for the current buffer asynchronously
---@param path string? defaults to the path to the current buffer
---@return {added: integer, removed: integer, changed: integer} diff stats
function M.diffstat(path)
  path = vim.fs.normalize(path or vim.api.nvim_buf_get_name(0))
  local dir = vim.fs.dirname(path)
  if dir then
    vim.system({
      'git',
      '-C',
      dir,
      '--no-pager',
      'diff',
      '-U0',
      '--no-color',
      '--no-ext-diff',
      '--',
      path,
    }, { stderr = false }, function(err, _)
      local stat = { added = 0, removed = 0, changed = 0 }
      for _, line in ipairs(vim.split(err.stdout, '\n')) do
        if line:find('^@@ ') then
          local num_lines_old, num_lines_new =
            line:match('^@@ %-%d+,?(%d*) %+%d+,?(%d*)')
          num_lines_old = tonumber(num_lines_old) or 1
          num_lines_new = tonumber(num_lines_new) or 1
          local num_lines_changed = math.min(num_lines_old, num_lines_new)
          stat.changed = stat.changed + num_lines_changed
          if num_lines_old > num_lines_new then
            stat.removed = stat.removed + num_lines_old - num_lines_changed
          else
            stat.added = stat.added + num_lines_new - num_lines_changed
          end
        end
      end
      buf_diffstats[path] = stat
    end)
  end
  return buf_diffstats[path] or { added = 0, removed = 0, changed = 0 }
end

--- Get the first worktree that a file belongs to
---@param file string? the file to check, defaults to the current file
---@param worktrees table<string, string>[]? an array like table of worktrees with entries `toplevel` and `gitdir`, default retrieves from `vim.g.git_worktrees`
---@return table<string, string>|nil # a table specifying the `toplevel` and `gitdir` of a worktree or nil if not found
function M.file_worktree(file, worktrees)
  -- worktrees = worktrees or vim.g.git_worktrees
  worktrees = worktrees
  if not worktrees then return end
  file = file or vim.fn.expand '%'
  for _, worktree in ipairs(worktrees) do
    if
      require('utils').command.cmd({
        'git',
        '--work-tree',
        worktree.toplevel,
        '--git-dir',
        worktree.gitdir,
        'ls-files',
        '--error-unmatch',
        file,
      }, false)
    then
      return worktree
    end
  end
end

return M
