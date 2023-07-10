# .nvim

> Dotfiles for NeoVim.

## Installation

```
git clone git@github.com:vollowx/.nvim.git ~/.config/nvim
nvim
```

## File Tree

```
├── lua
│  ├── core
│  │  ├── autocmds.lua ==> Auto Commands
│  │  ├── keymaps.lua  ==> Key-mappings
│  │  ├── options.lua  ==> Options
│  │  └── settings.lua ==> Settings
│  ├── plugins
│  │  ├── configs      ==> Configuations for Plugins
│  │  ├── modules      ==> Modules of Plugins
│  │  └── init.lua     ==> Entry of Plugins Controlling
│  └── utils           ==> Utilities
├── plugin             ==> Local Plugins
├── tests              ==> Features Test Files
├── init.lua           ==> Entry of Configs
├── lazy-lock.json     ==> Lock File of Plugin Manager
└── README.md
```
