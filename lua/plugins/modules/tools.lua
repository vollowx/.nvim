local map = require('utils').keymap.set

-- stylua: ignore start
map('n', '<C-p>', function() require('telescope.builtin').keymaps() end, { desc = 'ui: Open command panel' })
map('n', '<Leader>F', function() require('telescope.builtin').builtin() end, { desc = 'telescope: Find finders' })
map('n', '<Leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'telescope: Find files' })
map('n', '<Leader>fo', function() require('telescope.builtin').oldfiles() end, { desc = 'telescope: Find recent files' })
map('n', '<Leader>fw', function() require('telescope.builtin').live_grep() end, { desc = 'telescope: Find string' })
map('n', '<Leader>f*', function() require('telescope.builtin').grep_string() end, { desc = 'telescope: Find string' })
map('n', '<Leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'telescope: Find help pages' })
map('n', '<Leader>f/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = 'telescope: Find in current buffer' })
map('n', '<Leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'telescope: Find buffers' })
map('n', '<Leader>fr', function() require('telescope.builtin').lsp_references() end, { desc = 'telescope: Find LSP references' })
map('n', '<Leader>fd', function() require('telescope.builtin').lsp_definitions() end, { desc = 'telescope: Find LSP definitions' })
map('n', '<Leader>fa', function() require('telescope.builtin').lsp_code_actions() end, { desc = 'telescope: Find LSP code actions' })
map('n', '<Leader>fe', function() require('telescope.builtin').diagnostics() end, { desc = 'telescope: Find diagnostics' })
map('n', '<Leader>fp', function() require('telescope.builtin').treesitter() end, { desc = 'telescope: Find Treesitter symbols' })
map('n', '<Leader>fs', function() require('telescope.builtin').lsp_document_symbols() end, { desc = 'telescope: Find LSP document symbols' })
map('n', '<Leader>fS', function() require('telescope.builtin').lsp_workspace_symbols() end, { desc = 'telescope: Find LSP workspace symbols' })
map('n', '<Leader>fg', function() require('telescope.builtin').git_status() end, { desc = 'telescope: Find Git status' })
map('n', '<Leader>fm', function() require('telescope.builtin').marks() end, { desc = 'telescope: Find marks' })
map('n', '<Leader>fu', function() require('telescope').extensions.undo.undo() end, { desc = 'telescope: Find undoes' })
-- stylua: ignore end

map('tn', '<A-d>', '<cmd>ToggleTerm direction=float<cr>', { desc = 'terminal: Toggle floating' })
map('tn', '<A-\\>', '<cmd>ToggleTerm direction=vertical<cr>', { desc = 'terminal: Toggle vertical' })
map('tn', '<A-e>', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = 'terminal: Toggle horizontal' })

-- stylua: ignore start
map('n', ']g', function() require('gitsigns').next_hunk() end, { desc = 'git: Next Git hunk' })
map('n', '[g', function() require('gitsigns').prev_hunk() end, { desc = 'git: Previous Git hunk' })
map('n', '<Leader>gl', function() require('gitsigns').blame_line() end, { desc = 'git: View Git blame' })
map('n', '<Leader>gL', function() require('gitsigns').blame_line { full = true } end, { desc = 'git: View full Git blame' })
map('n', '<Leader>gp', function() require('gitsigns').preview_hunk() end, { desc = 'git: Preview Git hunk' })
map('n', '<Leader>gh', function() require('gitsigns').reset_hunk() end, { desc = 'git: Reset Git hunk' })
map('n', '<Leader>gr', function() require('gitsigns').reset_buffer() end, { desc = 'git: Reset Git buffer' })
map('n', '<Leader>gs', function() require('gitsigns').stage_hunk() end, { desc = 'git: Stage Git hunk' })
map('n', '<Leader>gS', function() require('gitsigns').stage_buffer() end, { desc = 'git: Stage Git buffer' })
map('n', '<Leader>gu', function() require('gitsigns').undo_stage_hunk() end, { desc = 'git: Unstage Git hunk' })
map('n', '<Leader>gd', function() require('gitsigns').diffthis() end, { desc = 'git: View Git diff' })
-- stylua: ignore end

local lazygit = nil
local toggle_lazygit = function()
  if vim.fn.executable 'lazygit' == 1 then
    if not lazygit then
      lazygit = require('toggleterm.terminal').Terminal:new {
        cmd = 'lazygit',
        direction = 'float',
        close_on_exit = true,
        hidden = true,
      }
    end
    lazygit:toggle()
  else
    vim.notify('[toggleterm.nvim] `lazygit` not found!', vim.log.levels.ERROR)
  end
end

map('tn', '<A-g>', toggle_lazygit, { desc = 'terminal: Toggle LazyGit' })

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'plenary.nvim',
      'telescope-fzf-native.nvim',
      'telescope-undo.nvim',
    },
    config = function() require 'plugins.configs.telescope' end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- If it complains 'fzf doesn't exists, run 'make' inside
    -- the root folder of this plugin
    build = 'make',
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'debugloop/telescope-undo.nvim',
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  -- {
  --   'willothy/flatten.nvim',
  --   event = 'BufReadPre',
  --   config = function()
  --     require('configs.flatten')
  --   end,
  -- },

  {
    'akinsho/toggleterm.nvim',
    cmd = {
      'Lazygit',
      'TermExec',
      'ToggleTerm',
      'ToggleTermSetName',
      'ToggleTermToggleAll',
      'ToggleTermSendCurrentLine',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = function() require 'plugins.configs.toggleterm' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'User NvGitFile',
    dependencies = 'plenary.nvim',
    config = function() require 'plugins.configs.gitsigns' end,
  },

  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Gcd',
      'Gclog',
      'Gdiffsplit',
      'Gdrop',
      'Gedit',
      'Ggrep',
      'Git',
      'Glcd',
      'Glgrep',
      'Gllog',
      'Gpedit',
      'Gread',
      'Gsplit',
      'Gtabedit',
      'Gvdiffsplit',
      'Gvsplit',
      'Gwq',
      'Gwrite',
    },
    config = function() require 'plugins.configs.vim-fugitive' end,
  },

  --[[ {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    config = true,
  }, ]]

  -- {
  --   'kevinhwang91/rnvimr',
  --   config = function()
  --     require('configs.rnvimr')
  --   end,
  -- },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'User NvFile',
    config = function() require 'plugins.configs.nvim-colorizer' end,
  },
}
