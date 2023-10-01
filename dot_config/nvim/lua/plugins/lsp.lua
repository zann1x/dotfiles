return {
    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
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
        end
    },

    -- Language Server Protocol
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- Progress indicator
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
                config = true,
            },
            -- Better Rust support
            {
                "simrat39/rust-tools.nvim",
                ft = "rs",
            },
        },
        keys = {
            { "<leader>e", vim.diagnostic.open_float, desc = "Open Floating Diagnostic Message" },
            { "[d", vim.diagnostic.goto_prev, desc = "Go To Previous Diagnostic Message" },
            { "]d", vim.diagnostic.goto_next, desc = "Go To Next Diagnostic Message" },
            { "<leader>q", vim.diagnostic.setloclist, desc = "Open Diagnostics List" },
            { "gD", vim.lsp.buf.declaration, "[G]o To [D]eclaration" },
            { "gd", vim.lsp.buf.definition, "[G]o To [D]efinition" },
            { "K", vim.lsp.buf.hover, "Hover documentation" },
            { "gi", vim.lsp.buf.implementation, "[G]o To [I]mplementation" },
            { "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation" },
            { "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition" },
            { "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame" },
            { "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction" },
            { "gr", vim.lsp.buf.references, "[G]o To [R]eferences" },
            { "<leader>fr", vim.lsp.buf.format, "[F]ile [R]eformat" },
        },
        config = function()
            -- nvim-cmp supports additional completion capabilities that need to be
            -- broadcast to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            checkOnSave = {
                                allFeatures = true,
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            procMacro = {
                                enable = true,
                            }
                        },
                    },
                },
            })

            -- Switch for controlling whether you want autoformatting.
            --  Use :LukasFormatToggle to toggle autoformatting on or off
            local format_is_enabled = true
            vim.api.nvim_create_user_command("LukasFormatToggle", function()
                format_is_enabled = not format_is_enabled
                print("Setting autoformatting to: " .. tostring(format_is_enabled))
            end, {})

            -- Create an augroup that is used for managing our formatting autocmds.
            --      We need one augroup per client to make sure that multiple clients
            --      can attach to the same buffer without interfering with each other.
            local _augroups = {}
            local get_augroup = function(client)
                if not _augroups[client.id] then
                    local group_name = "lukas-lsp-format-" .. client.name
                    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                    _augroups[client.id] = id
                end

                return _augroups[client.id]
            end

            -- Whenever an LSP attaches to a buffer, we will run this function.
            --
            -- See `:help LspAttach` for more information about this autocmd event.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lukas-lsp-attach-format", { clear = true }),
                -- This is where we attach the autoformatting for reasonable clients
                callback = function(args)
                    local client_id = args.data.client_id
                    local client = vim.lsp.get_client_by_id(client_id)
                    local bufnr = args.buf

                    -- Only attach to clients that support document formatting
                    if not client.server_capabilities.documentFormattingProvider then
                        return
                    end

                    -- Tsserver usually works poorly. Sorry you work with bad languages
                    -- You can remove this line if you know what you're doing :)
                    if client.name == "tsserver" then
                        return
                    end

                    -- Create an autocmd that will run *before* we save the buffer.
                    --  Run the formatting command for the LSP that has just attached.
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = get_augroup(client),
                        buffer = bufnr,
                        callback = function()
                            if not format_is_enabled then
                                return
                            end

                            vim.lsp.buf.format {
                                async = false,
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            }
                        end,
                    })
                end,
            })
        end,
    },

    -- Bridge the gap between LSP and formatter, linters and alike
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.formatting.golines,
                }
            })
        end,
    },
}
