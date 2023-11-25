local g = vim.g
local opt = vim.opt

-- stylua: ignore start
opt.cursorline     = true
opt.colorcolumn    = '80'
opt.foldlevelstart = 99
opt.guifont        = 'JetBrainsMono NF:h13'
opt.helpheight     = 10
opt.laststatus     = 3
opt.showmode       = false
opt.mouse          = 'a'
opt.mousemoveevent = true
opt.number         = true
opt.pumheight      = 16
opt.relativenumber = true
opt.ruler          = true
opt.scrolloff      = 4
opt.sidescrolloff  = 8
opt.signcolumn     = 'yes:1'
opt.splitright     = true
opt.splitbelow     = true
opt.swapfile       = false
opt.termguicolors  = true
opt.undofile       = true
opt.updatetime     = 10
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true -- Freeze nvim when editing long line with &wrap set
opt.smoothscroll   = true
opt.completeopt    = 'menuone'
opt.conceallevel   = 2
opt.concealcursor = 'nc'
opt.autowriteall   = true
opt.virtualedit    = 'block'
-- stylua: ignore end

-- Cursor shape
opt.gcr:append 'n-v:block-Cursor/lCursor,i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor,r-cr:hor20,o:hor50-Cursor/lCursor'

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
  fold      = ' ',
  foldopen  = '󰅀',
  foldclose = '󰅂',
  foldsep   = ' ',
  diff      = '╱',
  eob       = ' ',
}

opt.tabstop              = 2
opt.softtabstop          = 2
opt.shiftwidth           = 2
opt.expandtab            = true
opt.smartindent          = true
opt.autoindent           = true

opt.hlsearch             = true
opt.ignorecase           = true
opt.smartcase            = true

opt.spell                = false
opt.spellcapcheck        = ''
opt.spelllang            = 'en,cjk'
opt.spelloptions         = 'camel'
opt.spellsuggest         = 'best,9'
