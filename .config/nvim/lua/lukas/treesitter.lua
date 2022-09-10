require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cmake", "cpp", "go", "gomod", "rust" },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
    }
}
