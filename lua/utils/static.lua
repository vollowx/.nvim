local M = {}

local langs_mt = {}
langs_mt.__index = langs_mt

---@param field string
---@return string[]
function langs_mt:list(field)
  local deduplist = {}
  local result = {}
  -- deduplication
  for _, info in pairs(self) do
    if type(info[field]) == 'string' then
      deduplist[info[field]] = true
    elseif type(info[field]) == 'table' then
      for _, name in pairs(info[field]) do
        deduplist[name] = true
      end
    end
  end
  for name, _ in pairs(deduplist) do
    table.insert(result, name)
  end
  return result
end

---@param field string
---@return table<string, string|string[]>
function langs_mt:map(field)
  local result = {}
  for lang, info in pairs(self) do
    result[lang] = info[field]
  end
  return result
end

M.langs = setmetatable({
  sh = {
    ft = 'sh',
    lsp_server = 'bashls',
    dap = 'bashdb',
    formatters = { 'shfmt' },
  },
  c = {
    ts = 'c',
    ft = 'c',
    lsp_server = 'clangd',
    dap = 'codelldb',
    formatters = { 'clang-format' },
  },
  cpp = {
    ts = 'cpp',
    ft = 'cpp',
    lsp_server = 'clangd',
    dap = 'codelldb',
    formatters = { 'clang-format' },
  },
  css = {
    ts = 'css',
    ft = { 'css', 'scss', 'less' },
    lsp_server = 'cssls',
    formatters = { 'prettier' },
  },
  help = {
    ts = 'vimdoc',
    ft = 'help',
  },
  html = {
    ts = 'html',
    ft = 'html',
    lsp_server = 'html',
    formatters = { 'prettier' },
  },
  javascript = {
    ts = 'javascript',
    ft = 'js',
    -- lsp_server = 'tsserver',
    formatters = { 'prettier' },
  },
  json = {
    ts = 'json',
    ft = { 'json', 'jsonc' },
    lsp_server = 'jsonls',
    formatters = { 'prettier' },
  },
  typescript = {
    ts = 'typescript',
    ft = 'ts',
    -- lsp_server = 'tsserver',
    formatters = { 'prettier' },
  },
  lua = {
    ts = 'lua',
    ft = 'lua',
    lsp_server = 'lua_ls',
    formatters = { 'stylua' },
  },
  rust = {
    ts = 'rust',
    ft = 'rust',
    lsp_server = 'rust_analyzer',
    formatters = { 'rustfmt' },
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
    formatters = { 'nixfmt' },
  },
  python = {
    ts = 'python',
    ft = 'python',
    lsp_server = 'pyright',
    dap = 'debugpy',
    formatters = { 'black' },
  },
  yaml = {
    ts = 'yaml',
    ft = 'yaml',
    lsp_server = 'yamlls',
    formatters = { 'prettier' },
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
    formatters = { 'latexindent' },
  },
}, langs_mt)

-- stylua: ignore start
M.borders = {
  rounded               = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  single                = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  vintage               = { '-', '|', '-', '|', '+', '+', '+', '+' },
  rounded_clc           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  single_clc            = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  vintage_clc           = { '+', '-', '+', '|', '+', '-', '+', '|' },
  solid                 = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  none                  = { '', '', '', '', '', '', '', '' },
}
-- stylua: ignore end

M.icons = {
  diagnostics = {
    DiagnosticSignError = '󰅚 ',
    DiagnosticSignHint = '󰌶 ',
    DiagnosticSignInfo = '󰋽 ',
    DiagnosticSignOk = ' ',
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
    Package = '󰏖 ',
    Pair = '󰅪 ',
    Property = '󰓼 ',
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
    Terminal = '󰆍 ',
    Text = ' ',
    Type = '󰠲 ',
    TypeParameter = '󰆩 ',
    Unit = '󰑭 ',
    Value = '󰎠 ',
    Variable = '󰀫 ',
    WhileStatement = '󰑖 ',
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
    ClockFast = '󰅒 ',
    Diamond = '󰣏 ',
    Ellipsis = '… ',
    Flag = '󰈼 ',
    Ghost = '󰊠 ',
    Import = '󰋺 ',
    Keyboard = '󰌌 ',
    Note = '󱇗 ',
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
}

return M
