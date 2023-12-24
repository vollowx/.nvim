return {
  {
    'luukvbaal/statuscol.nvim',
    lazy = false,
    priority = 1000,
    opts = function()
      local builtin = require 'statuscol.builtin'
      return {
        segments = {
          {
            sign = {
              namespace = { 'gitsign.*' },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
            },
            click = 'v:lua.ScSa',
          },
          {
            text = { builtin.lnumfunc, ' ' },
            click = 'v:lua.ScLa',
            condition = { true, builtin.not_empty },
          },
          {
            text = { builtin.foldfunc },
            click = 'v:lua.ScFa',
            maxwidth = 1,
            colwidth = 1,
            auto = false,
          },
          {
            text = { ' ' },
            hl = 'Normal',
            condition = { true, builtin.not_empty },
          },
        },
      }
    end,
  },

  {
    'andymass/vim-matchup',
    event = 'BufReadPost',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = false }
    end,
  },

  {
    'RRethy/vim-illuminate',
    event = 'BufReadPost',
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {},
  },

  {
    'stevearc/dressing.nvim',
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        border = PREF.ui.interactive_border,
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
      select = {
        backend = 'builtin',
        builtin = {
          border = PREF.ui.interactive_border,
          relative = 'cursor',
          min_height = { 0, 0 },
        },
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '▏' },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },

  {
    'echasnovski/mini.bufremove',
    keys = {
      {
        'sd',
        function() require('mini.bufremove').delete() end,
      },
    },
  },

  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        options = {
          always_show_bufferline = false,
          indicator = { style = 'none' },
          separator_style = { '', '' },
          tab_size = 0,
          mode = 'tabs',
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_duplicate = false,
          enforce_regular_tabs = false,
        },
        highlights = require('catppuccin.groups.integrations.bufferline').get(),
      }
    end,
  },
}
