return {
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
}
