# ~/.config/nvim

## Get Started

### Install

```
git clone git@github.com:volpan/.nvim.git ~/.config/nvim
nvim
```

### File Tree

```
├── lua
│  ├── core
│  │  ├── autocmds.lua ==> Auto Commands
│  │  ├── init.lua     ==> Initialization for Core
│  │  ├── keymaps.lua  ==> Core Key-mappings
│  │  ├── options.lua  ==> NeoVim Options
│  │  └── settings.lua ==> Settings
│  ├── plugins
│  │  ├── configs      ==> Configuations for Plugins
│  │  │  └── configs... .lua
│  │  ├── modules      ==> Modules of Plugins
│  │  │  └── modules... .lua
│  │  └── init.lua     ==> Entry of Plugins Controlling
│  └── utils           ==> Utilities
│     └── utils... .lua
├── plugin             ==> Local Plugins
│  └── local-plugins... .lua
├── tests              ==> Features Test Files
│  └── tests... .*
├── init.lua           ==> Entry of Configs
├── lazy-lock.json
└── README.md
```
