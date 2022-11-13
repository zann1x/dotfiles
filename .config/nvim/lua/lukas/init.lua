vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

vim.opt.cmdheight = 2

vim.opt.showmatch = true

vim.opt.path:append('**')

vim.opt.wildmenu = true
vim.opt.wildignore:append('*/.git/*,*/*build*/*,*/target/*,*.lock')

vim.g.mapleader = " "

require('lukas.packer')

require('lukas.lsp')
require('lukas.telescope')
require('lukas.treesitter')
