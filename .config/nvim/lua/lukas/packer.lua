-- Ensure that the packer.nvim plugin manager is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manager itself
  use 'wbthomason/packer.nvim'

  -- Status line
  use 'vim-airline/vim-airline'

  -- Theme
  use 'morhetz/gruvbox'

  -- Automatically add closing parenthesis, quotes etc.
  use 'jiangmiao/auto-pairs'

  -- lodash but for nvim
  use 'nvim-lua/plenary.nvim'

  -- Cmake integration
  use {
    'Shatur/neovim-cmake',
    config = function()
      require'cmake'.setup({
        copy_compile_commands = false,
      })
    end
  }

  -- .editorconfig support
  use 'editorconfig/editorconfig-vim'

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  -- Telescope sorter to improve sorting performance
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }

  -- Language Server Protocol
  use 'neovim/nvim-lspconfig'
  -- Progress indicator for LSP
  use {
    'j-hui/fidget.nvim',
    config = function ()
      require'fidget'.setup()
    end
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        sync_install = false,
        highlight = {
          enable = true,
        }
      }
    end
  }
  -- Shows the context of the currently visible buffer contents
  use 'nvim-treesitter/nvim-treesitter-context'

  -- Automatically set up the configuration after cloning packer.nvim.
  -- This section must be placed after the definition of all other plugins.
  if packer_bootstrap then
    require("packer").sync()
  end
end)
