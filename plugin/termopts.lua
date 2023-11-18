---@param buf integer terminal buffer handler
---@return nil
local function term_set_keymaps_and_opts(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].bt ~= 'terminal' then
    return
  end
  vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>', { buffer = buf })
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
local function to_setup(buf)
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

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('TermOptsSetup', {}),
  callback = function(info) to_setup(info.buf) end,
})
