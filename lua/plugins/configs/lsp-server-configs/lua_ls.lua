return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
        disable = { 'different-requires' },
      },
      workspace = {
        library = {
          [vim.fn.expand '$VIMRUNTIME/lua'] = true,
          [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      format = { enable = false },
      telemetry = { enable = false },
      semantic = { enable = false },
    },
  },
}
