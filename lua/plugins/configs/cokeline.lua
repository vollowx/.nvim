local get_hex = require('cokeline/utils').get_hex

local icons = require('utils.static').icons

local str_rep = string.rep

local green_fg = get_hex('DiagnosticWarn', 'fg')
local red_fg = get_hex('DiagnosticError', 'fg')

local comments_fg = get_hex('Comment', 'fg')
local errors_fg = get_hex('DiagnosticError', 'fg')
local warnings_fg = get_hex('DiagnosticWarn', 'fg')

local min_buf_width = 18

local components = {
  separator = {
    text = ' ',
    bg = get_hex('Normal', 'bg'),
    truncation = { priority = 1 },
  },

  space = {
    text = ' ',
    truncation = { priority = 1 },
  },

  devicon = {
    text = function(buf) return buf.devicon.icon end,
    fg = function(buf) return buf.devicon.color end,
    truncation = { priority = 1 },
  },

  unique_prefix = {
    text = function(buf) return buf.unique_prefix end,
    fg = comments_fg,
    style = 'italic',
    truncation = {
      priority = 3,
      direction = 'left',
    },
  },

  filename = {
    text = function(buf) return buf.filename end,
    fg = function(buf)
      return (buf.diagnostics.errors ~= 0 and errors_fg) or (buf.diagnostics.warnings ~= 0 and warnings_fg) or nil
    end,
    style = function(buf) return buf.is_focused and 'bold' or nil end,
    truncation = {
      priority = 2,
      direction = 'left',
    },
  },

  close_or_unsaved = {
    text = function(buf) return buf.is_modified and icons.Dot or icons.Cross end,
    fg = function(buf) return buf.is_modified and green_fg or red_fg end,
    delete_buffer_on_left_click = true,
    truncation = { priority = 1 },
  },
}

local get_remaining_space = function(buf)
  local used_space = 0
  for _, component in pairs(components) do
    used_space = used_space
      + vim.fn.strwidth(type(component.text) == 'string' and component.text or component.text(buf))
  end
  return math.max(0, min_buf_width - used_space)
end

local left_padding = {
  text = function(buf)
    local remaining_space = get_remaining_space(buf)
    return str_rep(' ', remaining_space / 2 + remaining_space % 2)
  end,
}

local right_padding = {
  text = function(buf)
    local remaining_space = get_remaining_space(buf)
    return str_rep(' ', remaining_space / 2)
  end,
}

require('cokeline').setup {
  show_if_buffers_are_at_least = 2,

  buffers = {
    focus_on_delete = 'next',
    new_buffers_position = 'next',
  },

  rendering = {
    max_buffer_width = 24,
  },

  default_hl = {
    fg = get_hex('Normal', 'fg'),
    bg = function(buf) return buf.is_focused and get_hex('Normal', 'bg') or get_hex('TablineFill', 'bg') end,
  },

  sidebar = {
    filetype = 'NvimTree',
    components = {
      {
        text = '',
        bg = get_hex('NvimTreeNormal', 'bg'),
      },
    },
  },

  components = {
    components.space,
    components.space,
    left_padding,
    components.devicon,
    components.unique_prefix,
    components.filename,
    components.space,
    right_padding,
    components.close_or_unsaved,
    components.space,
  },
}
