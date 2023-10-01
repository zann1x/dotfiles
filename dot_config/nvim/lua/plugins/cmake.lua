return {
    -- CMake integration
    {
        "Shatur/neovim-cmake",
        config = function()
            require("cmake").setup({
                copy_compile_commands = true,
            })
        end,
    },
}
