local icons = require('utils.static').icons
local default_config = require('configs.lsp-server-configs.shared.default')

require('clangd_extensions').setup({
  server = default_config,
  extensions = {
    autoSetHints = false,
    inlay_hints = {
      only_current_line = true,
      highlight = 'LspInlayHint',
    },
    ast = {
      role_icons = {
        ['type'] = icons.Type,
        ['declaration'] = icons.Function,
        ['expression'] = icons.Snippet,
        ['specifier'] = icons.Specifier,
        ['statement'] = icons.Statement,
        ['template argument'] = icons.TypeParameter,
      },
      kind_icons = {
        ['Compound'] = icons.Namespace,
        ['Recovery'] = icons.DiagnosticSignError,
        ['TranslationUnit'] = icons.Unit,
        ['PackExpansion'] = icons.Ellipsis,
        ['TemplateTypeParm'] = icons.TypeParameter,
        ['TemplateTemplateParm'] = icons.TypeParameter,
        ['TemplateParamObject'] = icons.TypeParameter,
      },
    },
    memory_usage = {
      border = 'shadow',
    },
    symbol_info = {
      border = 'shadow',
    },
  },
})

-- Insert comparator in nvim-cmp's comparators list
local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
  cmp.setup.filetype({ 'c', 'cpp' }, {
    sorting = {
      comparators = vim.list_extend({
        require('clangd_extensions.cmp_scores'),
      }, require('cmp.config').get().sorting.comparators),
    },
  })
end
