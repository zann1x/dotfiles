vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons", -- Dependency
    "https://github.com/nvim-lualine/lualine.nvim"
})

require("lualine").setup({
    options = {
        theme = "auto",
    },
})
