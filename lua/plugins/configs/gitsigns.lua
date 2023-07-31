local border = require('core.settings').border

require('gitsigns').setup {
  preview_config = {
    border = border,
    style = 'minimal',
  },
  signs = {
    add = { text = '▎' },
    untracked = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '▎' },
    topdelete = { text = '▎' },
    changedelete = { text = '▎' },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local _map = require('utils.keymap').set
    local function map(modes, l, r, opts)
      opts = vim.tbl_deep_extend('force', opts, { buffer = bufnr })
      _map(modes, l, r, opts)
    end

    -- Navigation
    map('nx', ']c', function()
      if vim.wo.diff then
        vim.api.nvim_feedkeys(vim.v.count1 .. ']c', 'n', true)
        return
      end
      for _ = 1, vim.v.count1 do
        gs.next_hunk()
      end
    end, { desc = 'git: Next Git hunk' })

    map('nx', '[c', function()
      if vim.wo.diff then
        vim.api.nvim_feedkeys(vim.v.count1 .. '[c', 'n', true)
        return
      end
      for _ = 1, vim.v.count1 do
        gs.prev_hunk()
      end
    end, { desc = 'git: Previous Git hunk' })

    -- Actions
    map('n', '<Leader>gs', gs.stage_hunk, { desc = 'git: Stage hunk' })
    map('n', '<Leader>gr', gs.reset_hunk, { desc = 'git: Reset hunk' })
    map('n', '<Leader>gS', gs.stage_buffer, { desc = 'git: Stage buffer' })
    map('n', '<Leader>gu', gs.undo_stage_hunk, { desc = 'git: Undo stage hunk' })
    map('n', '<Leader>gR', gs.reset_buffer, { desc = 'git: Reset buffer' })
    map('n', '<Leader>gp', gs.preview_hunk, { desc = 'git: Preview hunk' })
    map('n', '<Leader>gb', gs.blame_line, { desc = 'git: Blame line' })

    -- Text object
    map('ox', 'ic', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = 'git: Select hunk' })
    map('ox', 'ac', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = 'git: Select hunk' })
  end,
}
