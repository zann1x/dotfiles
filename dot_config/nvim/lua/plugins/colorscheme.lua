return {
    -- Theme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                },
                contrast = "hard",
            })

            vim.cmd.colorscheme("gruvbox")
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        priority = 1000,
        opts = {
            options = {
                theme = "gruvbox",
            },
        },
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                priority = 1000,
            },
        },
    },
}
