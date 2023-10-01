return {
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
            { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "[P]roject [F]iles" },
            { "<leader>pg", "<cmd>Telescope git_files<cr>", desc = "[P]roject [G]it Files" },
            { "<leader>ps", "<cmd>Telescope live_grep<cr>", desc = "[P]roject [S]earch" },
        },
    },
}
