local adapters = {}

adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

adapters.bashdb = {
  type = 'executable',
  command = 'node',
  args = {
    vim.fn.stdpath 'data' .. '/vscode-bash-debug/extension/out/bashDebug.js',
  },
  name = 'bashdb',
}

adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'codelldb',
    args = { '--port', '${port}' },
  },
}

adapters.nlua = function(callback, config)
  callback {
    type = 'server',
    host = config.host or '127.0.0.1',
    port = config.port or 8086,
  }
end

return adapters
