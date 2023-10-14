---@param buf integer terminal buffer handler
---@return nil
local function term_set_keymaps_and_opts(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].bt ~= 'terminal' then
    return
  end
  vim.keymap.set('n', 'o', '<Cmd>startinsert<CR>', { buffer = buf })
  vim.keymap.set('t', '<C-Space>[', '<C-\\><C-n>', { buffer = buf })
  vim.keymap.set('t', '<Esc>', function()
    return require('utils').term.shall_esc()
        and (function()
          ---@diagnostic disable-next-line: undefined-field
          vim.b.t_esc = vim.uv.now()
          return true
        end)()
        and '<Cmd>stopinsert<CR>'
      or '<Esc>'
  end, {
    buffer = buf,
    expr = true,
    desc = 'Use <Esc> to exit terminal mode when running a shell.',
  })
  vim.keymap.set('n', '<Esc>', function()
    return vim.b.t_esc
        ---@diagnostic disable-next-line: undefined-field
        and vim.uv.now() - vim.b.t_esc <= vim.go.tm
        and require('utils').term.shall_esc()
        and '<Cmd>startinsert<CR><Esc>'
      or '<Esc>'
  end, {
    buffer = buf,
    expr = true,
    desc = 'Use <Esc> in normal mode to send <Esc> to terminal when running a shell.',
  })
  vim.opt_local.nu = false
  vim.opt_local.rnu = false
  vim.opt_local.statuscolumn = ''
  vim.opt_local.signcolumn = 'no'
  vim.opt_local.scrolloff = 0
  vim.opt_local.sidescrolloff = 0
  vim.cmd.startinsert()
end

---@param buf integer terminal buffer handler
---@return nil
local function setup(buf)
  term_set_keymaps_and_opts(buf)

  local groupid = vim.api.nvim_create_augroup('TermOpts', {})
  vim.api.nvim_create_autocmd('TermOpen', {
    group = groupid,
    desc = 'Set terminal keymaps and options, open term in split.',
    callback = function(info) term_set_keymaps_and_opts(info.buf) end,
  })

  vim.api.nvim_create_autocmd('TermEnter', {
    group = groupid,
    desc = 'Disable mousemoveevent in terminal mode.',
    command = 'let g:mousemev = &mousemev | set nomousemev',
  })

  vim.api.nvim_create_autocmd('TermLeave', {
    group = groupid,
    desc = 'Restore mousemoveevent after leaving terminal mode.',
    command = 'if exists("g:mousemev") | let &mousemev = g:mousemev | unlet g:mousemev | endif',
  })
end

return { setup = setup }
