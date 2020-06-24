" required for vundle
set nocompatible
filetype off

filetype plugin indent on
call plug#begin(stdpath('data') . '/plugged')
Plug 'neomake/neomake'
Plug 'gryf/wombat256grf'
call plug#end()

call neomake#configure#automake('nrwi', 500)

" look
colorscheme wombat256grf
syntax on
set background=dark
set cursorline relativenumber number

" keybindings
let mapleader=","
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <C-cr> :vsplit
nnoremap <C-l> :tabnext
nnoremap <C-h> :tabprev
nnoremap <C-j> :ta
nnoremap <leader>f :VsplitVifm<cr>

" jump to the next error
nnoremap <c-j> :lnext<cr>
nnoremap <c-k> :lprev<cr>

" exit using jk keys
inoremap jk <esc>
inoremap <esc> <nop>

" indentation
set autoindent expandtab shiftwidth=4 softtabstop=4

set mouse=a " enable mouse integration

" gvim look
set guioptions-=m
set guioptions-=T
set guioptions-=r

set foldmethod=manual
