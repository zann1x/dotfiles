-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- Number of screen lines for the command-line
vim.o.cmdheight = 2

-- Screen column to highlight
vim.o.colorcolumn = "80"

vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = "–– ", extends = ">", precedes = "<", space = "·", nbsp = "␣" }

-- Preview substitutions live, as you type
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 8

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- List of directories to search in with `:find` et al
vim.o.path = vim.o.path .. "**"

-- Enable 24-bit RGB color
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Quickly open netrw in the current directory
vim.keymap.set("n", "<leader>pv", ":Explore<CR>", { desc = "Open netrw in the current directory" })

-- Convenience for start and end of line without having to move my hands
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
vim.keymap.set("x", "<leader>p", "\"_dP")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('my-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- [[ Basic User commands ]]

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.

require("lazy").setup({
    -- Automatically finish pairs of... things
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("nvim-autopairs").setup({})

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )
        end,
    },

    -- CMake integration
    {
        "Shatur/neovim-cmake",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("cmake").setup({
                copy_compile_commands = true,
            })
        end,
    },

    -- Theme
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme moonfly]]
        end
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        priority = 1000,
        opts = {
            options = {
                theme = "codedark",
            },
        },
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                priority = 1000,
            },
        },
    },

    -- Convenient commenting of lines
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
    },

    -- Git integration
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
            "ibhagwan/fzf-lua",
        },
        keys = {
            { "<leader>gs", function() require("neogit").open() end, desc = "[G]it [S]tatus" },
        },
        config = true,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = {
                -- Required
                "c", "lua", "query", "vim", "vimdoc",
                -- Nice to have
                "bash", "cpp", "diff", "go", "markdown", "markdown_inline", "proto", "rust", "sql",
            },

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter`
            -- CLI installed locally
            auto_install = false,

            highlight = {
                enable = true,
                -- Setting this to true will run `:h syntax` and tree-sitter
                -- at the same time. Set this to `true` if you depend on
                -- 'syntax' being enabled (like for indentation). Using this
                -- option may slow down your editor, and you may see some
                -- duplicate highlights. Instead of true it can also be a
                -- list of languages
                additional_vim_regex_highlighting = false,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = {},
            indent = {},
            quickfile = {},
            words = {},
        },
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = require("telescope.actions").close,
                        },
                    },
                },
            })

            -- Enable telescope-fzf-native, if installed
            require("telescope").load_extension("fzf")
        end,
        keys = {
            { "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "[P]roject [B]uffers" },
            { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "[P]roject [F]iles" },
            { "<leader>pg", "<cmd>Telescope git_files<cr>", desc = "[P]roject [G]it Files" },
            { "<leader>ps", "<cmd>Telescope live_grep<cr>", desc = "[P]roject [S]earch" },
        },
    },

    -- Autoformat
    {
        "stevearc/conform.nvim",
        cmd = "ConformInfo",
        event = { "BufWritePre" },
        opts = {
            formatters_by_ft = {
                cpp = { "clang-format" },
                go = { "goimports", "golines", "gofmt" },
                rust = { "rustfmt" },
            },
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return {
                    lsp_format = "fallback",
                }
            end,
        },
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
                config = true,
            },
        },
        keys = {
            { "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["WARN"] or nil }) end, desc = "Go To Previous Warning Message" },
            { "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["WARN"] or nil }) end, desc = "Go To Next Warning Message" },
            { "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["ERROR"] or nil }) end, desc = "Go To Previous Error Message" },
            { "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["ERROR"] or nil }) end, desc = "Go To Next Error Message" },
            { "gD", vim.lsp.buf.declaration, "[G]o To [D]eclaration" },
            { "gd", vim.lsp.buf.definition, "[G]o To [D]efinition" },
            { "gi", vim.lsp.buf.implementation, "[G]o To [I]mplementation" },
            { "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition" },
            { "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame" },
            { "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction" },
            { "gr", vim.lsp.buf.references, "[G]o To [R]eferences" },
            { "<leader>fr", vim.lsp.buf.format, "[F]ile [R]eformat" },
        },
        config = function()
            vim.diagnostic.config({ virtual_text = true })

            vim.lsp.inlay_hint.enable(true)

            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            features = "all",
                        },
                    }
                }
            })

            vim.lsp.enable({
                "clangd",
                "gopls",
                "postgres_lsp",
                "protols",
                "rust_analyzer",
            })
        end
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- LSP source
            "hrsh7th/cmp-nvim-lsp",
            -- Highlight the current item in a signature's completion window
            "hrsh7th/cmp-nvim-lsp-signature-help",
            -- Source for vim's cmdline
            "hrsh7th/cmp-cmdline",
            -- Source vim-vsnip
            "hrsh7th/cmp-vsnip",
            -- VSCode(LSP)'s snippet feature
            "hrsh7th/vim-vsnip",
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    -- Accept currently selected item. Set `select` to `false`
                    -- to only confirm explicitly selected items.
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        -- Specify a snippet engine
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "vsnip" },
                }),
            })

            -- `/` and `?` cmdline setup.
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }
                }
            })

            -- `:` cmdline setup.
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" }
                        }
                    }
                })
            })

            vim.opt.completeopt = { "menuone", "noselect" }
        end
    },
})
