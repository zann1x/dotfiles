-- [[ LSP Configuration ]]
-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
    callback = function(event)
        -- We create a function that lets us more easily define mappings specific for
        -- LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map("[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["WARN"] or nil }) end, "Go To Previous Warning Message")
        map("]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["WARN"] or nil }) end, "Go To Next Warning Message")
        map("[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["ERROR"] or nil }) end, "Go To Previous Error Message")
        map("]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["ERROR"] or nil }) end, "Go To Next Error Message")
    
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('my-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
      
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
      
            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('my-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'my-lsp-highlight', buffer = event2.buf }
                end,
            })
        end
    
        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
        end
    end,
})

vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                features = "all",
                targetDir = true,
            },
        }
    }
})

vim.lsp.enable({
    "clangd",
    "gopls",
    "rust_analyzer"
})
