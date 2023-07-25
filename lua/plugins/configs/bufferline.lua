local bufferline = require 'bufferline'
local icons = require('utils.static').icons

bufferline.setup {
  options = {
    style_preset = bufferline.style_preset.no_italic,
    separator_style = { '', '' },
    indicator = { style = 'none' },
    buffer_close_icon = icons.ui.Cross,
    modified_icon = icons.ui.CircleSmall,
    left_trunc_marker = icons.ui.AngleLeft,
    right_trunc_marker = icons.ui.AngleRight,
    max_name_length = 20,
    max_prefix_length = 13,
    tab_size = 20,
    always_show_bufferline = false,
    offsets = {
      {
        filetype = 'NvimTree',
        text = '',
      },
    },
    highlights = require('catppuccin.groups.integrations.bufferline').get(),
  },
}
