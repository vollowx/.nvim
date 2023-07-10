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
    style = function(buffer)
      return
        buffer.is_focused
        and 'bold'
         or 'NONE'
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
      text = function(buffer) return buffer.filename .. ' ' end,
    },
    {
      text = function(buffer) return buffer.is_modified and icons.Dot or '' end,
    },
    {
      text = icons.Cross,
      fg = get_hex('Error', 'fg'),
      on_click = function(_, _, _, _, buffer)
        buffer:delete()
      end
    },
    {
      text = ' ',
    }
  },
})
