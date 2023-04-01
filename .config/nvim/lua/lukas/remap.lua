-- Most of the remaps are in the .vimrc to be accessible in normal terminals
-- as well. The remaps here are more or less specific to neovim.

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>fml', "<cmd>CellularAutomaton make_it_rain<CR>")
