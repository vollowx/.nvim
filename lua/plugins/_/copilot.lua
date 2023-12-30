require('copilot').setup {
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = '<C-f>',
      next = '<C-]>',
      prev = '<C-[>',
      dismiss = '<C-x>',
    },
  },
  filetypes = {
    markdown = true,
    help = true,
  },
}
