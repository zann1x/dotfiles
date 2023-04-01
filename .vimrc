set number
set relativenumber

set cursorline

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent

set incsearch
set hlsearch

set scrolloff=8

set colorcolumn=80
set signcolumn=auto

set cmdheight=2

set showmatch

set path+='**'

set wildmenu
set wildignore+='*/.git/*,*/*build*/*,*/target/*,*.lock'

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

nnoremap <silent> H ^
nnoremap <silent> L $
