-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Quickly open netrw in the current directory
vim.keymap.set("n", "<leader>pv", ":Explore<CR>", { desc = "Open netrw in the current directory" })

-- Convenience for start and end of line
vim.keymap.set("n", "H", "^", { desc = "Move to the start of the line" })
vim.keymap.set("n", "L", "$", { desc = "Move to the end of the line" })

-- Keep the cursor in the middle when jumping within a file
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move whole lines with automatic indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep the cursor in place when pulling a line up
vim.keymap.set("n", "J", "mzJ`z")

-- Don't lose the last copied word when pasting it over a selection
vim.keymap.set("x", "p", '"_dP')
