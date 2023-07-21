require('fidget').setup {
  text = {
    spinner = 'dots',
    done = vim.trim(require('utils.static').icons.ui.Check),
  },
  fmt = {
    fidget = function(fidget_name, spinner) return string.format('%s %s   ', spinner, fidget_name) end,
    task = function(task_name, message, percentage)
      return string.format(
        '%s%s (%s)   ',
        message,
        percentage and string.format(' [%s%%]', percentage) or '',
        task_name
      )
    end,
  },
}
