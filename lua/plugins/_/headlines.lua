local opts = {}
for _, ft in ipairs { 'markdown', 'norg', 'rmd', 'org' } do
  opts[ft] = {
    headline_highlights = {},
  }
  for i = 1, 6 do
    local hl = 'Headline' .. i
    vim.api.nvim_set_hl(0, hl, { link = 'Headline', default = true })
    table.insert(opts[ft].headline_highlights, hl)
  end
end

require('headlines').setup(opts)
