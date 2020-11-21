" required for vundle
set nocompatible
filetype off

filetype plugin indent on
call plug#begin(stdpath('data') . '/plugged')
Plug 'neomake/neomake'
Plug 'gryf/wombat256grf'
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips'
call plug#end()

call neomake#configure#automake('w', 0)

" look
syntax on
set background=dark
set cursorline relativenumber number

" keybindings
let mapleader="#"
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <C-l> :tabnext<cr>
nnoremap <C-h> :tabprev<cr>
nnoremap <leader>f :VsplitVifm<cr>
nnoremap <leader>m :make<cr>

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
let g:vimtex_view_method = 'zathura'

" neomake
let g:neomake_open_list = 0

" colorscheme
colorscheme wombat256grf

set scrolloff=10

" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"

" latex
function g:LatexMode()
    VimtexView
    nnoremap <c-t> :VimtexTocOpen<cr>
    nnoremap <c-c> :VimtexCompile<cr>
    set conceallevel=3
endfunction
autocmd FileType tex :call g:LatexMode()
