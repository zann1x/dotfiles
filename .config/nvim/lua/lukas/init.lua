vim.opt.termguicolors = true

vim.o.background = 'dark'

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

require('lukas.packer')

require('lukas.lsp')
