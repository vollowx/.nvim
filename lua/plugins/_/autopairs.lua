local npairs = require 'nvim-autopairs'
local Rule = require 'nvim-autopairs.rule'
local cond = require 'nvim-autopairs.conds'
local utils = require 'utils'

npairs.setup {
  check_ts = true,
  map_c_h = true,
  map_c_w = true,
  enable_abbr = true,
  disable_in_macro = true,
  enable_check_bracket_line = true,
  ignored_next_char = [=[[%w%%%'%[%"%.%`]]=],
  fast_wrap = {
    map = '<M-c>',
    chars = { '{', '[', '(', '"', "'", '`' },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    offset = 0, -- Offset from pattern match
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment',
  },
}

npairs.add_rules {
  -- Add spaces between parenthesis
  -- stylua: ignore start
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pairs_single_char = { '()', '[]', '{}' }
      local pairs_double_char = { '/**/' }
      local line_before_cur = opts.line:sub(1, opts.col-1)
      if
        vim.bo[opts.bufnr].ft == 'markdown'
        and utils.ft.markdown.in_normalzone()
        and (
          line_before_cur:match('^%s*[-*+]%s+%[$')
          or line_before_cur:match('^%s*%d+%.%s+%[$')
        )
      then
        pairs_single_char = { '()', '{}' }
      end
      return vim.tbl_contains(
        pairs_single_char,
        opts.line:sub(opts.col - 1, opts.col)
      ) or vim.tbl_contains(
        pairs_double_char,
        opts.line:sub(opts.col - 2, opts.col + 1)
      )
    end)
    :with_del(function(opts)
      return vim.fn.match(opts.line:sub(1, opts.col):reverse(),
        [[\s\((\|[\|{\|\*\/\)]]) == 0
    end),

  Rule('<<<', '>>>', { 'cuda' }),
  Rule('/*', '*/', { 'c', 'cpp' }),
  Rule('$', '$', { 'markdown', 'tex' })                                :with_pair(cond.none()),
  Rule('*', '*', { 'markdown' })                                       :with_pair(cond.none()),
  Rule('\\(', '\\)')                                                   :with_pair(cond.not_before_text('\\)')),
  Rule('\\(', '\\)', { 'tex' })                                        :with_pair(cond.not_before_text('\\)')),
  Rule('\\[', '\\]', { 'tex' })                                        :with_pair(cond.not_before_text('\\]')),
  Rule('\\{', '\\}', { 'tex', 'markdown' })                            :with_pair(cond.not_before_text('\\}')),
  Rule('\\left(', '\\right)', { 'markdown', 'tex' })                   :with_pair(cond.not_before_text('\\right)')),
  Rule('\\left[', '\\right]', { 'markdown', 'tex' })                   :with_pair(cond.not_before_text('\\right]')),
  Rule('\\left{', '\\right}', { 'markdown', 'tex' })                   :with_pair(cond.not_before_text('\\right}')),
  Rule('\\left<', '\\right>', { 'markdown', 'tex' })                   :with_pair(cond.not_before_text('\\right>')),
  Rule('\\left\\lfloor ',   ' \\right\\rfloor', { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\right\\rfloor)')),
  Rule('\\left\\lceil ',    ' \\right\\rceil',  { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\right\\rceil)')),
  Rule('\\left\\vert ',     ' \\right\\vert',   { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\right\\vert')),
  Rule('\\left\\lVert ',    ' \\right\\rVert',  { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\right\\lVert')),
  Rule('\\left\\lVert ',    ' \\right\\rVert',  { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\right\\lVert')),
  Rule('\\begin{bmatrix} ', ' \\end{bmatrix}',  { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\end{bmatrix}')),
  Rule('\\begin{pmatrix} ', ' \\end{pmatrix}',  { 'markdown', 'tex' }) :with_pair(cond.not_before_text('\\end{pmatrix}')),
  -- stylua: ignore end
}
-- stylua: ignore end
