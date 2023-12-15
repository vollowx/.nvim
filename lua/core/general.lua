vim.loader.enable()

local opt = vim.opt
local g = vim.g

-- stylua: ignore start
opt.cursorline     = true
opt.colorcolumn    = '80'
opt.foldlevelstart = 99
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

-- Font fot GUI
opt.guifont = 'CommitMono Nerd Font:h12'

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

-- Disable intro texts
opt.shortmess:append 'I'

-- stylua: ignore start
opt.list      = true
opt.listchars = {
  tab      = '→ ',
  extends  = '…',
  precedes = '…',
  nbsp     = '␣',
  trail    = '·',
}
opt.fillchars = {
  fold      = '·',
  foldopen  = '󰅀',
  foldclose = '󰅂',
  foldsep   = ' ',
  diff      = '╱',
  eob       = ' ',
}

opt.tabstop       = 2
opt.softtabstop   = 2
opt.shiftwidth    = 2
opt.expandtab     = true
opt.smartindent   = true
opt.autoindent    = true

opt.ignorecase    = true
opt.smartcase     = true

opt.spell         = true
opt.spellcapcheck = ''
opt.spelllang     = 'en,cjk'
opt.spelloptions  = 'camel'
opt.spellsuggest  = 'best,9'

-- disable plugins shipped with neovim
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
-- stylua: ignore end
