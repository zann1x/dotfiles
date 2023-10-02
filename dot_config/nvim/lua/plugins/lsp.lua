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
            { "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["WARN"] or nil }) end, desc = "Go To Previous Warning Message" },
            { "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["WARN"] or nil }) end, desc = "Go To Next Warning Message" },
            { "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["ERROR"] or nil }) end, desc = "Go To Previous Error Message" },
            { "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["ERROR"] or nil }) end, desc = "Go To Next Error Message" },
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
        end,
    },

    -- Bridge the gap between LSP and formatter, linters and alike
    {
        "stevearc/conform.nvim",
        cmd = "ConformInfo",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            formatters_by_ft = {
                cpp = { "clang-format" },
                go = { "goimports", "golines", "gofmt" },
                rust = { "rustfmt" },
            },
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return {
                    lsp_fallback = true,
                    timeout_ms = 500,
                }
            end,
        },
    },
}
