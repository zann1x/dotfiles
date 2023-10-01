return {
    -- Theme
    {
        "morhetz/gruvbox",
        lazy = false,
        config = function()
            vim.cmd("autocmd vimenter * ++nested colorscheme gruvbox")
            vim.g.gruvbox_contrast_dark = "hard"
        end,
    },

    -- Status line
    {
        "vim-airline/vim-airline",
        lazy = false,
        dependencies = {
            "vim-airline/vim-airline-themes",
            config = function()
                vim.g.airline_theme = "gruvbox"
            end,
        },
    },
}
