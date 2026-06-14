vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Display relative line numbers

vim.o.mouse = 'a' -- Enable mouse support

-- vim.o.timeoutlen = 300 -- Reduce time to complete commands

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- System clipboard is disabled when SSH'd into a server to prevent weird terminal behavior.
vim.schedule(function()
    vim.o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)

-- Indentation
vim.o.breakindent = true -- Indent lines on line break
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 4 -- Indent width
vim.o.softtabstop = 4 -- Soft tab stop

-- File handling
vim.o.swapfile = false -- Don't create swapfiles
vim.o.undofile = true -- Persistent undo
vim.o.updatetime = 250 -- Reduce general update time

-- Search settings
vim.o.ignorecase = true -- Case-insensitive search
vim.o.smartcase = true -- Case-sensitive search if uppercase letter in search

-- Visual settings
vim.o.cmdheight = 2 -- Number of screen lines for the command line
vim.o.confirm = true -- Confirm to save changes before existing a modified buffer
vim.o.cursorline = true -- Highlight current line
vim.o.colorcolumn = "80" -- Screen column to highligh
vim.o.inccommand = "split" -- Preview substitutions while typing
vim.o.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.o.showmode = false -- Don't show the current mode in the command line
vim.o.sidescrolloff = 8 -- Keep 8 lines left/right of cursor
vim.o.signcolumn = "yes" -- Always show sign column
vim.o.termguicolors = true -- Enable 24-bit RGB color
vim.o.wrap = false -- Don't wrap lines

vim.o.list = true
vim.opt.listchars = { tab = "–– ", extends = ">", precedes = "<", space = "·", nbsp = "␣" }

-- Split behavior
vim.o.splitbelow = true
vim.o.splitright = true
