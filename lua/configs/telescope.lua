local telescope = require 'telescope'
local static = require 'utils.static'

local border = require('init.settings').border

local rg_cmd = {
  'rg',
  '--hidden',
  '--vimgrep',
  '--column',
  '--line-number',
  '--smart-case',
  '--with-filename',
  '--no-heading',
  '--color=never',
  '-g=!*$*',
  '-g=!*%*',
  '-g=!*.bkp',
  '-g=!*.bz2',
  '-g=!*.db',
  '-g=!*.directory',
  '-g=!*.dll',
  '-g=!*.doc',
  '-g=!*.docx',
  '-g=!*.drawio',
  '-g=!*.gif',
  '-g=!*.git/',
  '-g=!*.gz',
  '-g=!*.ico',
  '-g=!*.ipynb',
  '-g=!*.iso',
  '-g=!*.jar',
  '-g=!*.jpeg',
  '-g=!*.jpg',
  '-g=!*.mp3',
  '-g=!*.mp4',
  '-g=!*.o',
  '-g=!*.otf',
  '-g=!*.out',
  '-g=!*.pdf',
  '-g=!*.pickle',
  '-g=!*.png',
  '-g=!*.ppt',
  '-g=!*.pptx',
  '-g=!*.pyc',
  '-g=!*.rar',
  '-g=!*.so',
  '-g=!*.svg',
  '-g=!*.tar',
  '-g=!*.ttf',
  '-g=!*.venv/',
  '-g=!*.xls',
  '-g=!*.xlsx',
  '-g=!*.zip',
  '-g=!*Cache*/',
  '-g=!*~',
  '-g=!*cache*/',
  '-g=!.*Cache*/',
  '-g=!.*cache*/',
  '-g=!.*wine/',
  '-g=!.cargo/',
  '-g=!.conda/',
  '-g=!.dot/',
  '-g=!.fonts/',
  '-g=!.ipython/',
  '-g=!.java/',
  '-g=!.jupyter/',
  '-g=!.luarocks/',
  '-g=!.mozilla/',
  '-g=!.npm/',
  '-g=!.nvm/',
  '-g=!.steam*/',
  '-g=!.thunderbird/',
  '-g=!.tmp/',
  '-g=!__pycache__/',
  '-g=!dosdevices/',
  '-g=!events.out.tfevents.*',
  '-g=!node_modules/',
  '-g=!vendor/',
  '-g=!venv/',
}

local fd_cmd = {
  'fd',
  '-p',
  '-H',
  '-L',
  '-tf',
  '-tl',
  '-d10',
  '--mount',
  '-c=never',
  '-E=*$*',
  '-E=*%*',
  '-E=*.bkp',
  '-E=*.bz2',
  '-E=*.db',
  '-E=*.directory',
  '-E=*.dll',
  '-E=*.doc',
  '-E=*.docx',
  '-E=*.drawio',
  '-E=*.gif',
  '-E=*.git/',
  '-E=*.gz',
  '-E=*.ico',
  '-E=*.ipynb',
  '-E=*.iso',
  '-E=*.jar',
  '-E=*.jpeg',
  '-E=*.jpg',
  '-E=*.mp3',
  '-E=*.mp4',
  '-E=*.o',
  '-E=*.otf',
  '-E=*.out',
  '-E=*.pdf',
  '-E=*.pickle',
  '-E=*.png',
  '-E=*.ppt',
  '-E=*.pptx',
  '-E=*.pyc',
  '-E=*.rar',
  '-E=*.so',
  '-E=*.svg',
  '-E=*.tar',
  '-E=*.ttf',
  '-E=*.venv/',
  '-E=*.xls',
  '-E=*.xlsx',
  '-E=*.zip',
  '-E=*Cache*/',
  '-E=*~',
  '-E=*cache*/',
  '-E=.*Cache*/',
  '-E=.*cache*/',
  '-E=.*wine/',
  '-E=.cargo/',
  '-E=.conda/',
  '-E=.dot/',
  '-E=.fonts/',
  '-E=.ipython/',
  '-E=.java/',
  '-E=.jupyter/',
  '-E=.luarocks/',
  '-E=.mozilla/',
  '-E=.npm/',
  '-E=.nvm/',
  '-E=.steam*/',
  '-E=.thunderbird/',
  '-E=.tmp/',
  '-E=__pycache__/',
  '-E=dosdevices/',
  '-E=events.out.tfevents.*',
  '-E=node_modules/',
  '-E=vendor/',
  '-E=venv/',
}

-- Dropdown layout for telescope
local layout_dropdown = {
  previewer = false,
  layout_config = {
    width = 0.6,
    height = 0.65,
  },
}

telescope.setup {
  defaults = {
    mappings = { i = { ['<Esc>'] = require('telescope.actions').close } },
    prompt_prefix = static.icons.ui.Magnify,
    selection_caret = static.icons.ui.ArrowRight,
    borderchars = static.borders[border],
    results_title = false,
    layout_strategy = 'flex',
    layout_config = {
      width = 0.8,
      height = 0.8,
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
      },
      vertical = {
        prompt_position = 'top',
        mirror = true,
      },
    },
    sorting_strategy = 'ascending',
    vimgrep_arguments = rg_cmd,
  },
  pickers = {
    colorscheme = { enable_preview = true },
    commands = layout_dropdown,
    command_history = layout_dropdown,
    filetypes = layout_dropdown,
    find_files = { find_command = fd_cmd },
    keymaps = layout_dropdown,
    live_grep = { additional_args = { '--hidden' } },
    lsp_references = { include_current_line = true, jump_type = 'never' },
    lsp_definitions = { jump_type = 'never' },
    lsp_type_definitions = { jump_type = 'never' },
    vim_options = layout_dropdown,
    registers = layout_dropdown,
    reloader = layout_dropdown,
    search_history = layout_dropdown,
    spell_suggest = layout_dropdown,
  },
  extensions = {
    undo = {
      use_delta = true,
      mappings = {
        i = {
          ['<CR>'] = require('telescope-undo.actions').restore,
        },
        n = {
          ['<CR>'] = require('telescope-undo.actions').restore,
          ['ya'] = require('telescope-undo.actions').yank_additions,
          ['yd'] = require('telescope-undo.actions').yank_deletions,
        },
      },
    },
  },
}

telescope.load_extension 'undo'
