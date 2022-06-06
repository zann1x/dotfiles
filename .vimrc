" enable line numbers
set number
set relativenumber

" highlight the current line
set cursorline

" indentation using spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set noerrorbells

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

" configure the gruvbox theme
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox
colorscheme gruvbox

syntax on
