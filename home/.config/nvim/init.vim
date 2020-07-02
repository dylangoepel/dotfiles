" required for vundle
set nocompatible
filetype off

filetype plugin indent on
call plug#begin(stdpath('data') . '/plugged')
Plug 'neomake/neomake'
Plug 'gryf/wombat256grf'
Plug 'lervag/vimtex'
call plug#end()

call neomake#configure#automake('w', 0)

" look
colorscheme wombat256grf
syntax on
set background=dark
set cursorline relativenumber number

" keybindings
let mapleader=","
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <C-l> :tabnext<cr>
nnoremap <C-h> :tabprev<cr>
nnoremap <leader>f :VsplitVifm<cr>

" jump to the next error
nnoremap <c-j> :lnext<cr>
nnoremap <c-k> :lprev<cr>

" open error list
nnoremap <c-e> :lwindow<cr><c-w>p

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

" vimtex
let g:tex_flavor = "latex"
let g:vimtex_view_general_viewer = 'zathura'

" neomake
let g:neomake_open_list = 0
