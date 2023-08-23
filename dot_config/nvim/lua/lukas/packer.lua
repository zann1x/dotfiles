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

  -- All the lua functions no one wants to write twice
  use 'nvim-lua/plenary.nvim'

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

  -- Git integration
  use 'tpope/vim-fugitive'

  -- Cmake integration
  use {
    'Shatur/neovim-cmake',
    config = function()
      require'cmake'.setup({
        copy_compile_commands = true,
      })
    end
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  -- Telescope sorter to improve sorting performance
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }

  -- Language Server Protocol
  use {
      'williamboman/mason.nvim',
      run = ":MasonUpdate" -- update registry contents
  }
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'

  -- Code completion
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp-signature-help' -- Highlight the current item in a signature's completion window
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-path' -- nvim-cmp source for filesystem paths
  use 'hrsh7th/cmp-cmdline' -- nvim-cmp source for vim's cmdline
  use 'hrsh7th/cmp-vsnip' -- nvim-cmp source vim-vsnip
  use 'hrsh7th/vim-vsnip' -- VSCode(LSP)'s snippet feature in vim/nvim

  -- Bridge the gap between LSP and formatters, linters and alike
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  -- Progress indicator for LSP
  use {
    'j-hui/fidget.nvim', tag = 'legacy',
    config = function ()
      require'fidget'.setup()
    end
  }

  -- Better Rust support
  use 'simrat39/rust-tools.nvim'

  -- Automatically finish pairs of... things
  use {
    'windwp/nvim-autopairs',
    requires = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  }

  -- Convenient commenting of lines
  use {
    'numToStr/Comment.nvim',
    config = function ()
      require('Comment').setup()
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
