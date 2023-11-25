local icons = require('utils.static').icons

return {
  {
    'p00f/clangd_extensions.nvim',
    dependencies = 'nvim-lspconfig',
    ft = { 'c', 'cpp' },
    config = function() end,
    opts = function()
      local default_config = require 'configs.lsp-server-configs.shared.default'
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
              ['type'] = icons.kinds.Type,
              ['declaration'] = icons.kinds.Function,
              ['expression'] = icons.kinds.Snippet,
              ['specifier'] = icons.kinds.Specifier,
              ['statement'] = icons.kinds.Statement,
              ['template argument'] = icons.kinds.TypeParameter,
            },
            kind_icons = {
              ['Compound'] = icons.kinds.Namespace,
              ['Recovery'] = icons.diagnostics.Error,
              ['TranslationUnit'] = icons.kinds.Unit,
              ['PackExpansion'] = icons.ui.Ellipsis,
              ['TemplateTypeParm'] = icons.kinds.TypeParameter,
              ['TemplateTemplateParm'] = icons.kinds.TypeParameter,
              ['TemplateParamObject'] = icons.kinds.TypeParameter,
            },
          },
          memory_usage = { border = 'shadow' },
          symbol_info = { border = 'shadow' },
        },
      }
    end,
  },
}
