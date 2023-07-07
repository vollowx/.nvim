local icons = require('utils.static').icons

require('nvim-web-devicons').setup({
  override = {
    default_icon = {
      color = '#b4b4b9',
      cterm_color = '249',
      icon = vim.trim(icons.File),
      name = 'Default',
    },
    desktop = {
      color = '#563d7c',
      cterm_color = '60',
      icon = vim.trim(icons.Desktop),
      name = 'DesktopEntry',
    },
  },
})
