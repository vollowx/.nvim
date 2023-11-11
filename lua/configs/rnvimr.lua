vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders none' }
vim.g.rnvimr_draw_border = 0
vim.g.rnvimr_action = {
  ['<A-t>'] = 'NvimEdit tabedit',
  ['<A-s>'] = 'NvimEdit split',
  ['<A-v>'] = 'NvimEdit vsplit',
  ['gw'] = 'JumpNvimCwd',
  ['yw'] = 'EmitRangerCwd',
}

local function rnvimr_update_layout()
  vim.g.rnvimr_layout = {
    relative = 'editor',
    anchor = 'NW',
    row = math.floor(0.7 * (vim.go.lines - vim.go.cmdheight)),
    col = 0,
    width = vim.go.columns,
    height = math.max(10, math.floor(0.35 * vim.go.lines)),
    style = 'minimal',
    border = 'solid',
  }
end
rnvimr_update_layout()
vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('RnvimrUpdateLayout', {}),
  callback = rnvimr_update_layout,
})

---Save and restore origin window views before and after calling fn
---@generic T
---@param wins integer[] window handlers
---@param fn fun(): T? function to call
---@return T?
local function win_call_keep_views(wins, fn)
  local views = {}
  for _, win in ipairs(wins) do
    views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
  end
  local ret = fn()
  for win, view in pairs(views) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_call(win, function() vim.fn.winrestview(view) end)
    end
  end
  return ret
end

-- Set cmdheight to 0 when rnvimr is visible so that the floating
-- terminal window fully occupies the bottom of the screen
vim.api.nvim_create_augroup('RnvimrSetCmdHeight', {})
vim.api.nvim_create_autocmd(
  { 'TabNewEntered', 'TabEnter', 'TermEnter', 'WinEnter' },
  {
    group = 'RnvimrSetCmdHeight',
    desc = 'Set cmdheight to 0 when rnvimr is visible.',
    callback = function()
      local tab_wins = vim.api.nvim_tabpage_list_wins(0)
      -- If rnvimr is opened in current tab, set cmdheight to 0
      for _, win in ipairs(tab_wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].ft == 'rnvimr' then
          if not vim.g.cmdheight then vim.g.cmdheight = vim.go.cmdheight end
          if vim.go.cmdheight ~= 0 then
            win_call_keep_views(tab_wins, function() vim.go.cmdheight = 0 end)
            vim.g.redraw_pending = true
          end
          return
        end
      end
      -- Else restore cmdheight to its original value
      if vim.g.cmdheight then
        if vim.go.cmdheight ~= vim.g.cmdheight then
          win_call_keep_views(
            tab_wins,
            function() vim.go.cmdheight = vim.g.cmdheight end
          )
          vim.g.redraw_pending = true
        end
        vim.g.cmdheight = nil
      end
    end,
  }
)

vim.api.nvim_create_autocmd('WinClosed', {
  group = 'RnvimrSetCmdHeight',
  desc = 'Restore cmdheight when rnvimr is closed.',
  callback = function(info)
    local win = tonumber(info.match) --[[@as integer]]
    if
      vim.g.cmdheight
      and vim.g.cmdheight ~= vim.go.cmdheight
      and vim.api.nvim_win_is_valid(win)
      and vim.bo[vim.api.nvim_win_get_buf(win)].ft == 'rnvimr'
    then
      win_call_keep_views(
        vim.api.nvim_tabpage_list_wins(0),
        function() vim.go.cmdheight = vim.g.cmdheight end
      )
      vim.g.cmdheight = nil
      vim.g.redraw_pending = true
    end
  end,
})

-- Redraw screen on TanEnter/TabNewEntered if cmdheight is changed but
-- the screen has not been redrawn yet
-- This prevents the new tab from showing two statuslines in the new tab when
-- the previous tab has rnvimr opened (cmdheight = 0) but the current one does
-- not and has cmdheight = 1
vim.api.nvim_create_autocmd({ 'TabEnter', 'TabNewEntered' }, {
  group = 'RnvimrSetCmdHeight',
  desc = 'Redraw screen on TanEnter/TabNewEntered if cmdheight is changed but the screen has not been redrawn yet.',
  callback = function()
    if vim.g.redraw_pending then
      vim.cmd.mode()
      vim.g.redraw_pending = nil
    end
  end,
})

local function rnvimr_toggle()
  local current_wintype = vim.fn.win_gettype(vim.api.nvim_get_current_win())
  local current_filetype = vim.bo[vim.api.nvim_get_current_buf()].filetype
  if current_wintype ~= '' and current_filetype ~= 'rnvimr' then return end
  local winlist = vim.api.nvim_list_wins()
  for _, winnr in ipairs(winlist) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if
      vim.api.nvim_win_get_config(winnr).relative ~= ''
      and vim.fn.getwinvar(winnr, '&buftype') == 'terminal'
      and vim.fn.getbufvar(bufnr, '&filetype') ~= 'rnvimr'
    then
      vim.api.nvim_win_close(winnr, true)
    end
  end
  vim.cmd 'silent! RnvimrToggle'
end

return {
  toggle = rnvimr_toggle,
}
