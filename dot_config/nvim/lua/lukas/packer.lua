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
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Status line
  use 'vim-airline/vim-airline'
  use {
    'vim-airline/vim-airline-themes',
    config = function ()
      vim.g.airline_theme = 'gruvbox'
    end
  }

  -- Theme
  use {
    'morhetz/gruvbox',
    config = function ()
      vim.cmd('autocmd vimenter * ++nested colorscheme gruvbox')
      vim.g.gruvbox_contrast_dark = 'hard'
    end
  }

  -- When shit hits the fan
  use 'eandrju/cellular-automaton.nvim' 

  -- Git integration
  use 'tpope/vim-fugitive'

  -- Cmake integration
  use {
    'Shatur/neovim-cmake',
    config = function()
      require'cmake'.setup({
        copy_compile_commands = false,
      })
    end
  }

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
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- Code completion
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp-signature-help' -- Highlight the current item in a signature's completion window
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-path' -- nvim-cmp source for filesystem paths
  use 'hrsh7th/cmp-cmdline' -- nvim-cmp source for vim's cmdline
  use 'hrsh7th/cmp-vsnip' -- nvim-cmp source vim-vsnip
  use 'hrsh7th/vim-vsnip' -- VSCode(LSP)'s snippet feature in vim/nvim

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
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
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
