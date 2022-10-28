" enable line numbers
set number
" show relative line numbers
set relativenumber

" highlight the current line
set cursorline

" indentation using spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" highlight search results already when typing the search term
set incsearch

" already scroll before the end of the page is reached
set scrolloff=8

" show the 'end of line' column at position x
set colorcolumn=80
" show the bar left of the text available for e.g. syntax error indications
set signcolumn=yes

" show the matching parenthesis
set showmatch

" enable highlight search pattern
set hlsearch

" give messages a little more room to breathe
set cmdheight=2

" when searching for a file, also search in all subdirectories
set path+=**

" display all matching files when searching and trying to tab complete
set wildmenu
" files to ignore when searching
set wildignore+=*/.git/*,*/*build*/*,*/target/*,*.lock

" set internal encoding of vim
set encoding=utf-8

" plugins to install
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" nice status line
Plug 'vim-airline/vim-airline'

" theme
Plug 'morhetz/gruvbox'

" automatically add closing parenthesis, quote etc.
Plug 'jiangmiao/auto-pairs'

" (generally useful) helper functions (for some plugins)
Plug 'nvim-lua/plenary.nvim'

" cmake integration
Plug 'Shatur/neovim-cmake'

" fuzzy finder
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" fuzzy file finder
" -> install the latest version of the binary in the post-update hook
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" language server protocol
Plug 'neovim/nvim-lspconfig'

" treesitter
" -> update all modules in the post-update hook
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

call plug#end()

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set background=dark
let g:gruvbox_contrast_dark = 'hard'
autocmd vimenter * ++nested colorscheme gruvbox

lua << EOF
-- require additional local lua files with configuration in them
require('lukas/cmake')
require('lukas/lsp')
require('lukas/telescope')
require('lukas/treesitter')
EOF
