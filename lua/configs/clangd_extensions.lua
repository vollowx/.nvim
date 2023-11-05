local icons = require('utils.static').icons
local default_config = require 'configs.lsp-server-configs.shared.default'

local border = require('init.settings').border

require('clangd_extensions').setup {
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
    memory_usage = {
      border = border,
    },
    symbol_info = {
      border = border,
    },
  },
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
