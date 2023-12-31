local opt = vim.opt
local g = vim.g

-- stylua: ignore start
opt.cursorline     = true
opt.colorcolumn    = '80'
opt.foldcolumn     = PREF.ui.show_fold_signcolumn and 'auto' or '0'
opt.foldlevelstart = 99
opt.foldmethod     = 'expr'
opt.foldtext       = 'v:lua.vim.treesitter.foldtext()'
opt.foldexpr       = 'v:lua.vim.treesitter.foldexpr()'
opt.helpheight     = 10
opt.showmode       = false
opt.mousemoveevent = true
opt.number         = true
opt.ruler          = true
opt.pumheight      = 16
opt.scrolloff      = 4
opt.sidescrolloff  = 8
opt.signcolumn     = 'yes:1'
opt.splitright     = true
opt.splitbelow     = true
opt.swapfile       = false
opt.termguicolors  = true
opt.undofile       = true
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.smoothscroll   = true
opt.conceallevel   = 2
opt.autowriteall   = true
opt.virtualedit    = 'block'
opt.completeopt    = 'menuone'
-- stylua: ignore end

if not vim.g.gui then
  -- nvim 0.10.0 automatically enables termguicolors. When using nvim inside
  -- tmux in Linux tty, where $TERM is set to 'tmux-256color' but $DISPLAY is
  -- not set, termguicolors is automatically set. This is undesirable, so we
  -- need to explicitly disable it in this case
  opt.termguicolors = false
  opt.cursorlineopt = 'number'
end

-- Recognize numbered lists when formatting text
opt.formatoptions:append 'n'

-- Font fot GUI
opt.guifont = 'JetBrainsMono Nerd Font:h12'

-- Cursor shape
opt.gcr = {
  'i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor',
  'n-v:block-Curosr/lCursor',
  'o:hor50-Curosr/lCursor',
  'r-cr:hor20-Curosr/lCursor',
}

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
opt.diffopt:append 'algorithm:histogram'

-- Use system clipboard
opt.clipboard:append 'unnamedplus'

opt.backup = true
opt.backupdir:remove '.'

-- Disable completion messages
opt.shortmess:append 'c'

-- stylua: ignore start
opt.list = true
opt.listchars = {
  tab      = '→ ',
  trail    = '·',
}
opt.fillchars = {
  fold      = ' ',
  foldsep   = ' ',
  eob       = ' ',
}
if g.gui then
  opt.listchars:append({ nbsp = '␣' })
  opt.fillchars:append({
    foldopen  = '󰅀',
    foldclose = '󰅂',
    diff      = '╱',
  })
end

opt.tabstop       = PREF.editor.tabsize
opt.softtabstop   = PREF.editor.tabsize
opt.shiftwidth    = PREF.editor.tabsize
opt.expandtab     = true
opt.smartindent   = true
opt.autoindent    = true

opt.ignorecase    = true
opt.smartcase     = true

opt.spellcapcheck = ''
opt.spelllang     = 'en,cjk'
opt.spelloptions  = 'camel'
opt.spellsuggest  = 'best,9'

-- disable plugins
g.loaded_2html_plugin      = 1
g.loaded_gzip              = 1
g.loaded_matchit           = 1
g.loaded_tar               = 1
g.loaded_tarPlugin         = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimball           = 1
g.loaded_vimballPlugin     = 1
g.loaded_zip               = 1
g.loaded_zipPlugin         = 1

-- disable providers
g.loaded_node_provider    = 0
g.loaded_perl_provider    = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider    = 0
-- stylua: ignore end
