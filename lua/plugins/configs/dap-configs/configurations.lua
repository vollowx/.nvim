local dapconfig = {}

---@class dapcache_t
---@field program string|nil program path
---@field args table<string, string> args[program] = args for program

---Cache program path, args, etc.
---@type table<string, dapcache_t>
local cache = {
  python = {
    args = {},
  },
  sh = {
    args = {},
  },
  cpp = {
    args = {},
  },
}

dapconfig.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    args = function()
      local args = ''
      local fname = vim.fn.expand '%:t'
      vim.ui.input({
        prompt = 'Enter arguments: ',
        default = cache.python.args[fname],
        completion = 'file',
      }, function(input)
        args = input
        cache.python.args[fname] = args
        vim.cmd.stopinsert()
      end)
      return vim.split(args, ' ')
    end,
    pythonPath = function()
      local venv = vim.fs.find({ 'venv', '.venv' }, {
        path = vim.fn.expand '%:p:h',
        upward = true,
      })[1]
      if venv and vim.fn.executable(venv .. '/bin/python') == 1 then return venv .. '/bin/python' end
      return vim.fn.exepath 'python'
    end,
  },
}

dapconfig.sh = {
  {
    type = 'bashdb',
    request = 'launch',
    name = 'Launch file',
    showDebugOutput = true,
    pathBashdb = vim.fn.stdpath 'data' .. '/vscode-bash-debug/extension/bashdb_dir/bashdb',
    pathBashdbLib = vim.fn.stdpath 'data' .. '/vscode-bash-debug/extension/bashdb_dir/',
    trace = true,
    file = '${file}',
    program = '${file}',
    cwd = '${workspaceFolder}',
    pathCat = 'cat',
    pathBash = '/bin/bash',
    pathMkfifo = 'mkfifo',
    pathPkill = 'pkill',
    args = function()
      local args = ''
      local fname = vim.fn.expand '%:t'
      vim.ui.input({
        prompt = 'Enter arguments: ',
        default = cache.sh.args[fname],
        completion = 'file',
      }, function(input)
        args = input
        cache.sh.args[fname] = args
        vim.cmd.stopinsert()
      end)
      return vim.split(args, ' ')
    end,
    env = {},
    terminalKind = 'integrated',
  },
}

dapconfig.cpp = {
  {
    type = 'codelldb',
    name = 'Launch file',
    request = 'launch',
    program = function()
      local program
      vim.ui.input({
        prompt = 'Enter path to executable: ',
        default = vim.fs.find({ vim.fn.expand '%:t:r', 'a.out' }, {
          path = vim.fn.expand '%:p:h',
          upward = true,
        })[1] or cache.cpp.program,
        completion = 'file',
      }, function(input)
        program = input
        cache.cpp.program = program
        vim.cmd.stopinsert()
      end)
      return vim.fn.fnamemodify(program, ':p')
    end,
    args = function()
      local args = ''
      local fpath_base = vim.fn.expand '%:p:r'
      vim.ui.input({
        prompt = 'Enter arguments: ',
        default = cache.cpp.program and cache.cpp.args[cache.cpp.program] or cache.cpp.args[fpath_base],
        completion = 'file',
      }, function(input)
        args = input
        cache.cpp.args[cache.cpp.program or fpath_base] = args
        vim.cmd.stopinsert()
      end)
      return vim.split(args, ' ')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dapconfig.c = dapconfig.cpp

dapconfig.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}

return dapconfig
