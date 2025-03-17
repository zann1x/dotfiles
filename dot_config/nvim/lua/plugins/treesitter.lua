return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        dependencies = {
            -- Show the context of the currently visible buffer contents
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            -- See `:help nvim-treesitter`
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    -- Required
                    "c", "lua", "query", "vim", "vimdoc",
                    -- Nice to have
                    "cpp", "go", "proto", "rust", "sql",
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

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
            })
        end
    },
}
