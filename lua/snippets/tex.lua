local M = {}
local un = require 'snippets.utils.nodes'
local us = require 'snippets.utils.snips'
local ls = require 'luasnip'
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

M.math = require 'snippets.shared.math'

M.env = {
  us.sM(
    { trig = 'env' },
    un.fmtad(
      [[
        \begin{<env>}
        <idnt><text>
        \end{<env>}
      ]],
      {
        idnt = un.idnt(1),
        env = i(1),
        text = i(0),
      }
    )
  ),
  us.sM({ trig = 'cs' }, {
    t {
      '\\begin{equation}',
      '\\begin{cases}',
      '',
    },
    un.idnt(1),
    i(1),
    t {
      '',
      '\\end{cases}',
      '\\end{equation}',
    },
  }),
  us.sM(
    { trig = 'aln' },
    un.fmtad(
      [[
        \begin{<env>}
        <idnt><text>
        \end{<env>}
      ]],
      {
        env = c(1, {
          i(nil, 'align*'),
          i(nil, 'align'),
        }),
        idnt = un.idnt(1),
        text = i(0),
      }
    )
  ),
  us.sM(
    { trig = 'eqt' },
    un.fmtad(
      [[
        \begin{<env>}
        <idnt><text>
        \end{<env>}
      ]],
      {
        env = c(1, {
          i(nil, 'equation*'),
          i(nil, 'equation'),
        }),
        idnt = un.idnt(1),
        text = i(0),
      }
    )
  ),
}

M.style = {
  us.sM({ trig = 'em' }, { t '\\emph{', i(1), t '}' }),
  us.sM({ trig = 'bf' }, { t '\\textbf{', i(1), t '}' }),
  us.sM({ trig = 'ul' }, { t '\\underline{', i(1), t '}' }),
}

M.style_auto = {
  us.sM({
    trig = '^(%s*)- ',
    regTrig = true,
    hidden = true,
    snippetType = 'autosnippet',
  }, f(function(_, snip, _) return snip.captures[1] .. '\\item' end)),
  us.sM(
    {
      trig = '\\item(%w)',
      regTrig = true,
      hidden = true,
      snippetType = 'autosnippet',
    },
    d(
      1,
      function(_, snip)
        return sn(nil, {
          t('\\item{' .. snip.captures[1]),
          i(1),
          t '}',
        })
      end
    )
  ),
}

return M
