require('clangd_extensions').setup {
  inlay_hints = {
    highlight = 'LspInlayHint',
  },
  ast = {
    role_icons = {
      ['type'] = PREF.icons.kinds.Type,
      ['declaration'] = PREF.icons.kinds.Function,
      ['expression'] = PREF.icons.ui.Circle,
      ['specifier'] = PREF.icons.kinds.Specifier,
      ['statement'] = PREF.icons.kinds.Statement,
      ['template argument'] = PREF.icons.kinds.TypeParameter,
    },
    kind_icons = {
      ['Compound'] = PREF.icons.kinds.Namespace,
      ['Recovery'] = PREF.icons.diagnostics.Error,
      ['TranslationUnit'] = PREF.icons.kinds.Unit,
      ['PackExpansion'] = PREF.icons.ui.Ellipsis,
      ['TemplateTypeParm'] = PREF.icons.kinds.TypeParameter,
      ['TemplateTemplateParm'] = PREF.icons.kinds.TypeParameter,
      ['TemplateParamObject'] = PREF.icons.kinds.TypeParameter,
    },
  },
  memory_usage = { border = PREF.ui.border },
  symbol_info = { border = PREF.ui.hover_border },
}

-- Insert comparator in nvim-cmp's comparators list
local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
  cmp.setup.filetype({ 'c', 'cpp' }, {
    sorting = {
      comparators = vim.list_extend({
        require 'clangd_extensions.cmp_scores',
      }, require('cmp.config').get().sorting.comparators),
    },
  })
end
