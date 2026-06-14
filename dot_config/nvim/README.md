# Requirements:

LSP:

```sh
# C support
sudo apt-get install clangd

# Go support
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/segmentio/golines@latest

# Rust support
rustup component add rust-analyzer
```

Treesitter:

```sh
cargo install --locked tree-sitter-cli
```
