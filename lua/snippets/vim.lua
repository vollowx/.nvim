local M = {}
local un = require('snippets.utils.nodes')
local us = require('snippets.utils.snips')
local ls = require('luasnip')
local i = ls.insert_node
local t = ls.text_node

M.snippets = {
  us.msn({
    { trig = 'e' },
    { trig = 'ech' },
    { trig = 'echom' },
  }, t('echom ')),
  us.msn(
    {
      { trig = 'eck' },
      { trig = 'echeck' },
    },
    un.fmtad('echom <q><v>: <q> <v>', {
      q = un.qt(),
      v = i(1),
    })
  ),
  us.msn(
    {
      common = { priority = 999 },
      { trig = 'ck' },
      { trig = 'check' },
    },
    un.fmtad('<q><v>: <q> <v>', {
      q = un.qt(),
      v = i(1),
    })
  ),
}

return M
