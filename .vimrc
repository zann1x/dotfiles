set number
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent

set incsearch
set hlsearch

set scrolloff=8

set termguicolors
set background=dark

set colorcolumn=80
set signcolumn=auto

set cmdheight=2
set updatetime=50

set showmatch

set path+='**'

set wildmenu
set wildignore+='*/.git/*,*/*build*/*,*/target/*,*.lock'

let mapleader=' '

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz

nnoremap <silent> H ^
nnoremap <silent> L $
