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

vim.opt.termguicolors = true

vim.o.background = 'dark'

vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- Center search results
vim.keymap.set('n', 'n', 'nzz', opts)
vim.keymap.set('n', 'N', 'Nzz', opts)
vim.keymap.set('n', '*', '*zz', opts)
vim.keymap.set('n', '#', '#zz', opts)

-- Jump to start and end of line more conveniently
vim.keymap.set('n', 'H', '^', opts)
vim.keymap.set('n', 'L', '$', opts)

require('lukas.packer')

require('lukas.lsp')
require('lukas.telescope')
