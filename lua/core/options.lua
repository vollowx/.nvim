local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- stylua: ignore start
opt.cursorline     = true
opt.cursorlineopt  = 'number'
opt.colorcolumn    = '120'
opt.foldlevelstart = 99
opt.guifont        = 'Liga SFMono Nerd Font:h12'
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
opt.splitbelow     = true
opt.splitright     = true
opt.swapfile       = false
opt.termguicolors  = true
opt.undofile       = true
opt.updatetime     = 10
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.smoothscroll   = true
opt.completeopt    = 'menu,menuone,noselect'
opt.conceallevel   = 2
opt.autowriteall   = true
-- stylua: ignore end

-- Transparent
opt.pumblend = 0
opt.winblend = 0

-- Cursor shape
opt.gcr:append 'n-v:block-Cursor/lCursor,i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor,r-cr:hor20,o:hor50-Cursor/lCursor'

-- Use patience algorithm for diffing
opt.diffopt:append 'algorithm:patience'

opt.backup = true
opt.backupdir:remove '.'

-- Disable intro texts
opt.shortmess:append 'I'

-- stylua: ignore start
opt.list = true
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

opt.tabstop     = 2
opt.softtabstop = 2
opt.shiftwidth  = 2
opt.expandtab   = true
opt.smartindent = true
opt.autoindent  = true

opt.hlsearch    = true
opt.ignorecase  = true
opt.smartcase   = true

opt.spell         = true
opt.spellcapcheck = ''
opt.spelllang     = 'en,cjk'
opt.spelloptions  = 'camel'
opt.spellsuggest  = 'best,9'

-- disable plugins shipped with neovim
g.loaded_gzip            = 1
g.loaded_tar             = 1
g.loaded_tarPlugin       = 1
g.loaded_zip             = 1
g.loaded_zipPlugin       = 1
g.loaded_getscript       = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball         = 1
g.loaded_vimballPlugin   = 1
g.loaded_matchit         = 1
g.loaded_2html_plugin    = 1
g.loaded_logiPat         = 1
g.loaded_rrhelper        = 1
g.loaded_netrw           = 1
g.loaded_netrwPlugin     = 1
-- stylua: ignore end
