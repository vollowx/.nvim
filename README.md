# .nvim

> Dotfiles for NeoVim.

## Installation

```
git clone git@github.com:vollowx/.nvim.git ~/.config/nvim
nvim
```

## Structure

```
├── lua
│  ├── core
│  │  ├── autocmds.lua ==> Auto Commands
│  │  ├── keymaps.lua  ==> Basic Key-bindings
│  │  ├── options.lua  ==> NeoVim Options
│  │  └── settings.lua ==> Global Settings
│  ├── plugins
│  │  ├── configs      ==> Configuations for Plugins
│  │  ├── modules      ==> Modules of Plugins
│  │  └── init.lua     ==> Entry of Plugins Controlling
│  └── utils           ==> Utilities
├── plugin             ==> Local Plugins
├── tests              ==> Features Testing Files
├── init.lua           ==> Entry of Configs
├── lazy-lock.json     ==> Lock File of Plugin Manager
└── README.md
```

## Todoes

- [x] Inlay hints
- [x] `dressing.nvim`
- [ ] `noice.nvim`, maybe
- [ ] `nvim-dap`
- [ ] [lsp_line.nvim](https://git.sr.ht/~whynothugo/lsp_lines.nvim)
- [ ] `vim-easy-align`
- [ ] `vimtex`
