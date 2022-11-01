
set nocompatible

if has('filetype')
    filetype indent plugin on
endif

if has('syntax')
    syntax on
endif

set number
set relativenumber

set noerrorbells

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent

set nowrap

set hlsearch
set incsearch
set ignorecase
set smartcase

set noswapfile
set nobackup
set undofile

set scrolloff=8
set signcolumn="yes"

set cmdheight=1

set updatetime=50

set colorcolumn=80

set completeopt="menu,menuone,noselect"

let mapleader=" "

nnoremap <leader>pv <cmd>Ex<CR>

nnoremap <leader>x <cmd>!chmod +x %<CR>

nnoremap <leader>y "+y
vnoremap <leader>y "+y
map <leader>Y "+Y

