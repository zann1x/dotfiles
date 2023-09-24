source ~/.vimrc

lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Git integration
    "tpope/vim-fugitive",

    -- Theme
    {
        "morhetz/gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("autocmd vimenter * ++nested colorscheme gruvbox")
            vim.g.gruvbox_contrast_dark = "hard"
        end,
    },

    -- Status line
    {
        "vim-airline/vim-airline",
        lazy = false,
        priority = 1000,
        dependencies = {
            "vim-airline/vim-airline-themes",
            config = function()
                vim.g.airline_theme = "gruvbox"
            end,
        },
    },

    -- CMake integration
    {
        "Shatur/neovim-cmake",
        config = function()
            require("cmake").setup({
                copy_compile_commands = true,
            })
        end,
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
    },

    -- Language Server Protocol
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                config = true,
            },
            "williamboman/mason-lspconfig.nvim",
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
                opts = {},
            },
        },
    },

    -- Bridge the gap between LSP and formatter, linters and alike
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    -- Better Rust support
    "simrat39/rust-tools.nvim",

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- LSP source
            "hrsh7th/cmp-nvim-lsp",
            -- Highlight the current item in a signature's completion window
            "hrsh7th/cmp-nvim-lsp-signature-help",
            -- Source for buffer words
            "hrsh7th/cmp-buffer",
            -- Source for filesystem paths
            "hrsh7th/cmp-path",
            -- Source for vim's cmdline
            "hrsh7th/cmp-cmdline",
            -- Source vim-vsnip
            "hrsh7th/cmp-vsnip",
            -- VSCode(LSP)'s snippet feature
            "hrsh7th/vim-vsnip",
        },
    },

    -- Automatically finish pairs of... things
    {
        "windwp/nvim-autopairs",
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

    -- Convenient commenting of lines
    {
        "numToStr/Comment.nvim",
        opts ={},
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            -- Show the context of the currently visible buffer contents
            "nvim-treesitter/nvim-treesitter-context",
        },
    },

    -- Automatically format via the respective LSP server
    require("custom.plugins.autoformat")
}, {})

-- [[ Configuration ]]
-- Diagnostic keymaps
-- See `:help vim.diagnostic.*`
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Floating Diagnostic Message" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go To Previous Diagnostic Message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go To Next Diagnostic Message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostics List" })

-- Open Git
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]tatus" })

-- [[ Configure telescope ]]
-- Enable telescope-fzf-native, if installed
require("telescope").load_extension("fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, { desc = "[P]roject [F]iles" })
vim.keymap.set("n", "<leader>pg", require("telescope.builtin").git_files, { desc = "[P]roject [G]it Files" })
vim.keymap.set("n", "<leader>ps", require("telescope.builtin").live_grep, { desc = "[P]roject [S]earch" })

-- [[ Configure treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        -- Required
        "c", "lua", "query", "vim", "vimdoc",
        -- Nice to have
        "cpp", "go", "rust",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
        { name = "buffer", keyword_length = 5 },
        { name = "path" },
        { name = "vsnip" },
    }, {
        { name = "buffer" },
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

-- [[ Configure LSP ]]
-- Use an on_attach function to only map the following keys after the language
-- server attaches to the current buffer.
local on_attach = function(client, bufnr)
    -- LSP mappings.
    -- See `:help vim.lsp.*`
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("gD", vim.lsp.buf.declaration, "[G]o To [D]eclaration")
    nmap("gd", vim.lsp.buf.definition, "[G]o To [D]efinition")
    nmap("K", vim.lsp.buf.hover, "Hover documentation")
    nmap("gi", vim.lsp.buf.implementation, "[G]o To [I]mplementation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("gr", vim.lsp.buf.references, "[G]o To [R]eferences")
    nmap("<leader>fr", vim.lsp.buf.format, "[F]ile [R]eformat")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

-- nvim-cmp supports additional completion capabilities that need to be
-- broadcast to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure that servers managed by mason are configured
require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end,
})

-- Language servers to enable
local servers = {
    "clangd",
    "gopls",
    -- Rust is managed by rust-tools
    -- "rust"
}

-- Ensure the servers above are installed
for _, server in ipairs(servers) do
    require("lspconfig")[server].setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })
end

-- Set up extended rust support additionally
require("rust-tools").setup({
    server = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
})

-- Set up additional LSP support through null-ls
local null_ls = require("null-ls")
require("null-ls").setup({
    sources = {
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.golines,
    }
})
EOF
