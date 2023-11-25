local telescope = require 'telescope'
local static = require 'utils.static'

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
    prompt_prefix = '/ ',
    selection_caret = static.icons.ui.ArrowRight,
    borderchars = static.borders.solid,
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
    find_files = { find_command = fd_cmd },
    keymaps = layout_dropdown,
    live_grep = { additional_args = { '--hidden' } },
    lsp_references = { include_current_line = true, jump_type = 'never' },
    lsp_definitions = { jump_type = 'never' },
    lsp_type_definitions = { jump_type = 'never' },
    spell_suggest = layout_dropdown,
  },
}
