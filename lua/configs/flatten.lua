require('flatten').setup {
  window = {
    open = 'alternate',
  },
  callbacks = {
    should_block = function(argv)
      for _, arg in ipairs(argv) do
        if arg:find('.git/rebase-merge', 1, true) then return true end
      end
      return false
    end,
    post_open = function(bufnr, winnr, ft, is_blocking)
      if is_blocking or ft == 'gitcommit' or ft == 'gitrebase' then
        -- Hide the terminal while it's blocking
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if
            vim.api
              .nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
              :find '#toggleterm#'
          then
            require('toggleterm').toggle(0)
            vim.t.toggleterm_hidden = true
          end
        end
      else
        -- If it's a normal file, just switch to its window
        vim.api.nvim_set_current_win(winnr)
      end
      -- If the file is a git commit or git rebase, create one-shot autocmd to
      -- delete its buffer on write
      if ft == 'gitcommit' or ft == 'gitrebase' then
        vim.api.nvim_create_autocmd('BufWritePost', {
          buffer = bufnr,
          once = true,
          callback = function()
            vim.defer_fn(function() vim.api.nvim_buf_delete(bufnr, {}) end, 50)
            return true
          end,
        })
      end
    end,
    block_end = function()
      -- After blocking ends (for a git commit, etc), reopen the terminal
      vim.defer_fn(function()
        if vim.t.toggleterm_hidden then
          require('toggleterm').toggle(0)
          vim.t.toggleterm_hidden = nil
        end
      end, 50)
    end,
  },
  one_per = {
    kitty = false,
    wezterm = false,
  },
}
