return {
  -- Core
  use_ssh = false,

  -- Appearance
  transparent = false,
  border = 'single',
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
      Event = '󱐋 ',
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
      Rename = '󰜶 ',
      Remove = '󰛲 ',
      Unmerged = ' ',
      Untracked = '󰘥 '
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
      Bug = '󰨰',
      Code = '󰅴 ',
      Cog = '󰢻 ',
      Command = '󰘳 ',
      Cross = '󰅖 ',
      Check = '󰄬 ',
      CheckCircle = '󰗠 ',
      CheckList = '󰗇 ',
      Circle = '󰝥 ',
      CircleUnfilled = '󰝦 ',
      CircleSmall = '󰧞 ',
      Diamond = '󰣏 ',
      Ellipsis = '… ',
      FileDocument = '󰈙 ',
      Flag = '󰈼 ',
      FolderEmpty = '󰉖 ',
      FolderEmptyOpen = '󰷏 ',
      FolderLink = '󰉒 ',
      FolderOpen = '󰝰 ',
      Ghost = '󰊠 ',
      Import = '󰋺 ',
      Keyboard = '󰌌 ',
      Magnify = '󰍉 ',
      Package = '󰏖 ',
      Pencil = '󰲶 ',
      Pin = '󰐃 ',
      Sleep = '󰒲 ',
      Square = '󰝤 ',
      TriangleDown = '▼ ',
      TriangleLeft = '◀ ',
      TriangleRight = '▶ ',
      TriangleUp = '▲ ',
      Vim = ' ',
    },
  },

  -- Language Specified
  langs = {
    sh = {
      ft = 'sh',
      lsp_server = 'bashls',
      dap = 'bashdb',
      formatting = 'shfmt',
    },
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
    css = {
      ts = 'css',
      ft = { 'css', 'scss', 'less' },
      lsp_server = 'cssls',
      formatting = 'prettier',
    },
    help = {
      ts = 'vimdoc',
      ft = 'help',
    },
    html = {
      ts = 'html',
      ft = 'html',
      lsp_server = 'html',
      formatting = 'prettier',
    },
    javascript = {
      ts = 'javascript',
      ft = 'js',
      lsp_server = 'tsserver',
      formatting = 'prettier',
    },
    json = {
      ts = 'json',
      ft = { 'json', 'jsonc' },
      lsp_server = 'jsonls',
      formatting = 'prettier',
    },
    typescript = {
      ts = 'typescript',
      ft = 'ts',
      lsp_server = 'tsserver',
      formatting = 'prettier',
    },
    lua = {
      ts = 'lua',
      ft = 'lua',
      lsp_server = 'lua_ls',
      formatting = 'stylua',
    },
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
    markdown = {
      ts = {
        'markdown_inline',
        'markdown',
      },
      lsp_server = 'marksman',
    },
    nix = {
      ts = 'nix',
      lsp_server = 'nil_ls',
      formatting = 'nixfmt',
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
    yaml = {
      -- ts = 'yaml',
      ft = 'yaml',
      lsp_server = 'yamlls',
      formatting = 'prettier',
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
}
