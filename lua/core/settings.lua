return {
  use_ssh = false,

  colorscheme = 'catppuccin',
  transparent_background = true,

  palette_overwrite = {},

  langs = {
    -- paru -S bash-language-server shfmt
    sh = {
      ft = 'sh',
      lsp_server = 'bashls',
      dap = 'bashdb',
      formatting = 'shfmt',
    },
    -- paru -S clang
    c = {
      ts = 'c',
      ft = 'c',
      lsp_server = 'clangd',
      dap = 'codelldb',
      formatting = 'clang-format',
    },
    cpp = {
      ts = 'cpp',
      ft = 'cpp',
      lsp_server = 'clangd',
      dap = 'codelldb',
      formatting = 'clang-format',
    },
    help = {
      ts = 'vimdoc',
      ft = 'help',
    },
    -- paru -S lua-language-server stylua
    lua = {
      ts = 'lua',
      ft = 'lua',
      lsp_server = 'lua_ls',
      formatting = 'stylua',
    },
    -- paru -S rustup rust-analyzer
    rust = {
      ts = 'rust',
      ft = 'rust',
      lsp_server = 'rust_analyzer',
      formatting = 'rustfmt',
    },
    make = {
      ts = 'make',
      ft = 'make',
    },
    -- paru -S marksman
    markdown = {
      ts = {
        'markdown_inline',
        'markdown',
      },
      lsp_server = 'marksman',
    },
    python = {
      ts = 'python',
      ft = 'python',
      lsp_server = {
        'pylsp',
        'pyright',
        'jedi_language_server',
      },
      dap = 'debugpy',
      formatting = 'black',
    },
    vim = {
      ts = 'vim',
      ft = 'vim',
      lsp_server = 'vimls',
    },
    tex = {
      ft = 'tex',
      ts = 'latex',
      lsp_server = 'texlab',
      formatting = 'latexindent',
    },
  },
  icons = {
    debug = {
      StackFrame = ' ',
      StackFrameCurrent = ' ',
    },
    diagnostics = {
      DiagnosticSignError = '󰅚 ',
      DiagnosticSignHint = '󰌶 ',
      DiagnosticSignInfo = '󰋽 ',
      DiagnosticSignOk = '󰄬 ',
      DiagnosticSignWarn = '󰀪 ',
    },
    kinds = {
      Array = '󰅪 ',
      Boolean = ' ',
      BreakStatement = '󰙧 ',
      Calculator = '󰃬 ',
      Call = '󰃷 ',
      CaseStatement = '󱃙 ',
      Class = ' ',
      Color = '󰸌 ',
      Constant = '󰏿 ',
      Constructor = '󰢻 ',
      ContinueStatement = '→ ',
      Copilot = ' ',
      Declaration = '󰙠 ',
      Delete = '󰩺 ',
      Desktop = '󰟀 ',
      DoStatement = '󰑖 ',
      Enum = ' ',
      EnumMember = ' ',
      Event = ' ',
      Field = ' ',
      File = '󰈔 ',
      Folder = '󰉋 ',
      ForStatement = '󰑖 ',
      Format = '󰗈 ',
      Function = '󰊕 ',
      GitBranch = ' ',
      H1Marker = '󰉫 ',
      H2Marker = '󰉬 ',
      H3Marker = '󰉭 ',
      H4Marker = '󰉮 ',
      H5Marker = '󰉯 ',
      H6Marker = '󰉰 ',
      Identifier = '󰀫 ',
      IfStatement = '󰇉 ',
      Interface = ' ',
      Keyword = '󰌋 ',
      List = '󰅪 ',
      Log = '󰦪 ',
      Lsp = ' ',
      Macro = '󰁌 ',
      MarkdownH1 = '󰉫 ',
      MarkdownH2 = '󰉬 ',
      MarkdownH3 = '󰉭 ',
      MarkdownH4 = '󰉮 ',
      MarkdownH5 = '󰉯 ',
      MarkdownH6 = '󰉰 ',
      Method = '󰆧 ',
      Module = '󰏗 ',
      Namespace = '󰅩 ',
      Null = '󰢤 ',
      Number = '󰎠 ',
      Object = '󰅩 ',
      Operator = '󰆕 ',
      Package = '󰆦 ',
      Pair = '󰅪 ',
      Property = ' ',
      Reference = '󰦾 ',
      Regex = ' ',
      Repeat = '󰑖 ',
      Scope = '󰅩 ',
      Snippet = '󰩫 ',
      Specifier = '󰦪 ',
      Statement = '󰅩 ',
      String = '󰉾 ',
      Struct = ' ',
      SwitchStatement = '󰺟 ',
      Terminal = ' ',
      Text = ' ',
      Type = ' ',
      TypeParameter = '󰆩 ',
      Unit = ' ',
      Value = '󰎠 ',
      Variable = '󰀫 ',
      WhileStatement = '󰑖 ',
    },
    git = {
      Add = '󰜄 ',
      Mod = '󱗝 ',
      Remove = '󰛲 ',
    },
    ui = {
      AngleDown = '󰅀 ',
      AngleLeft = '󰅁 ',
      AngleRight = '󰅂 ',
      AngleUp = '󰅃 ',
      ArrowDown = '󰁅 ',
      ArrowLeft = '󰁍 ',
      ArrowRight = '󰁔 ',
      ArrowUp = '󰁝 ',
      Cross = '󰅖 ',
      Magnify = '󰍉 ',
      Ok = '󰄬 ',
      Diamond = '󰣏 ',
      Dot = '󰧞 ',
      DotLarge = '󰝥 ',
      Ellipsis = '… ',
      Pin = '󰐃 ',
      TriangleDown = '▼ ',
      TriangleLeft = '◀ ',
      TriangleRight = '▶ ',
      TriangleUp = '▲ ',
    },
  },
}
