local get_hex = require('cokeline/utils').get_hex

local icons = require('utils.static').icons

require('cokeline').setup({
  default_hl = {
    fg = function(buffer)
      return
        buffer.is_focused
        and get_hex('Normal', 'fg')
         or get_hex('Normal', 'fg')
    end,
    bg = function(buffer)
      return
        buffer.is_focused
        and get_hex('Normal', 'bg')
         or get_hex('TablineFill', 'bg')
    end,
  },

  sidebar = {
    filetype = 'NvimTree',
    components = {
      {
        text = '',
        bg = function()
          return get_hex('NvimTreeNormal', 'bg')
        end,
      },
    }
  },

  components = {
    {
      text = '  ',
    },
    {
      text = function(buffer) return buffer.devicon.icon end,
      fg = function(buffer) return buffer.devicon.color end,
    },
    {
      text = function(buffer) return buffer.filename end,
    },
    {
      text = '  ',
    }
  },
})
