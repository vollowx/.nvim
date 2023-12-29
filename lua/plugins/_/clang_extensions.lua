local default_config = require 'plugins._.lsp.default'

return {
  server = default_config,
  extensions = {
    autoSetHints = true,
    inlay_hints = {
      only_current_line = false,
      highlight = 'LspInlayHint',
    },
    ast = {
      role_icons = {
        ['type'] = PREF.icons.kinds.Type,
        ['declaration'] = PREF.icons.kinds.Function,
        ['expression'] = PREF.icons.kinds.Snippet,
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
    memory_usage = { border = 'shadow' },
    symbol_info = { border = 'shadow' },
  },
}
