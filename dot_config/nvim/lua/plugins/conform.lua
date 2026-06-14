vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
require('conform').setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return {
            lsp_format = "fallback",
        }
    end,
    default_format_opts = {
        lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
        cpp = { "clang-format" },
        go = { "goimports", "golines", "gofmt" },
        rust = { 'rustfmt' },
    },
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
