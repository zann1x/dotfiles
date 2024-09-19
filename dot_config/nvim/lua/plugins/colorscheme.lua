return {
    -- Theme
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("moonfly")
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
}
