# .nvim

> Dotfiles for Neovim.

## About

_Highly inspired by [Bekaboo/nvim](https://github.com/Bekaboo/nvim)_

This repository contains my personal configuration for Neovim. It is a highly opinionated setup that is designed to meet my own needs, but feel free to take a look around and use whatever you like.

## Installation

```bash
git clone git@github.com:vollowx/.nvim.git ~/.config/nvim
nvim
```

In order to prevent duplicated packages installed (especially in NixOS), unlike other configurations using `meson.nvim`, you need to install the following external packages manually.

- LSP servers: `clangd`, `cssls`, `lua_ls`, `marksman`, `tsserver`
- Formatters: `clang-format`, `prettier`, `eslint`

## Structure

```
.
├── colors                      # colorschemes
├── plugin                      # custom plugins
├── ftplugin                    # custom filetype plugins
├── init.lua                    # entry of config
└── lua
    ├── core                    # files under this folder is required by 'init.lua'
    │   ├── preferences.lua     # general settings
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── autocmds.lua
    │   └── packages.lua        # bootstraps package manager and specifies what packages to include
    ├── modules                 # all plugin specifications and configs go here
    │   ├── lib.lua             # plugin specifications in module 'lib'
    │   ├── completion.lua      # plugin specifications in module 'completion'
    │   ├── lsp.lua             # plugin specifications in module 'lsp'
    │   ├── tools.lua
    │   ├── treesitter.lua
    │   └── colorschemes.lua
    ├── configs                 # configs for each plugin
    ├── snippets                # snippets
    └── utils
```

## Todos

- [ ] `nvim-dap`
- [ ] [lsp_line.nvim](https://git.sr.ht/~whynothugo/lsp_lines.nvim)
- [x] `vim-easy-align`
