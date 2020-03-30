" required for vundle
set nocompatible
filetype off

filetype plugin indent on
call plug#begin(stdpath('data') . '/plugged')
Plug 'neomake/neomake'
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'nanotech/jellybeans.vim'
Plug 'airblade/vim-rooter'
call plug#end()

let g:jellybeans_overrides = {
\    'background': { 'guibg': '222222' },
\}
colorscheme jellybeans

if &term == 'xterm-256color' || &term == 'screen-256color'
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[1 q"
endif

syntax on

" automatically cd to project root
let g:rooter_silent_chdir = 1

let g:ycm_rust_src_path = '/usr/local/rust/rustc-1.8.0/src'

" look
set background=dark
set cursorline relativenumber number

" keybindings
let mapleader=","
map ö <leader>
nnoremap <leader>a :Gwrite<cr>
nnoremap <leader>u :Gpush<cr>
nnoremap <leader>l :Gpull<cr>
nnoremap <leader>L :Glog<cr>
nnoremap <leader>c :Gcommit<cr>
nnoremap <leader>g :Git 
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>m :! make<cr>
nnoremap <Left> :tabprevious<cr>
nnoremap <Right> :tabnext<cr>
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-cr> :vsplit

" jump to the next error
noremap <c-e> <c-o>:lnext<cr>

" exit using jk keys
inoremap jk <esc>
inoremap <esc> <nop>

" dont use arrow keys
inoremap <up> <nop>
inoremap <right> <nop>
inoremap <left> <nop>
inoremap <down> <nop>

" indentation
set autoindent expandtab shiftwidth=4 softtabstop=4

function OnPython()
    nnoremap <leader>r :! python3 %<cr>
endfunction

function OnGo()
    nnoremap <leader>r :! go run .<cr>
endfunction

function OnShell()
    nnoremap <leader>r :! bash %<cr>
endfunction

function OnRust()
    nnoremap <leader>r :! cargo run<cr>
endfunction

function OnC()
    nnoremap <leader>r :! gcc % -o /tmp/tempProgram && /tmp/tempProgram<cr>
endfunction

function OnHTML()
    nnoremap <leader>t yypli/<esc>
endfunction

function OnLatex()
    iabbrev \documentclass{article} \documentclass{article}<cr>\usepackage[ngerman]{babel}<cr>\usepackage[utf8]{inputenc}<cr>\usepackage{}<cr>\begin{document}<cr>\end{document}<cr>
endfunction

" filetype specific key bindings
augroup vimrc
    autocmd!
    
    " automatical file-type dependant settings
    au BufEnter *.py call OnPython()
    au BufEnter *.go call OnGo()
    au BufEnter *.sh call OnShell()
    au BufEnter *.rs call OnRust()
    au BufEnter *.c call OnC()
    au BufEnter *.tex call OnLatex()
    au BufEnter *.html,*.htm call OnHTML()

    " try to compile after every save
    au BufWritePost * Neomake
augroup END

set mouse=a " enable mouse integration

" gvim look
set guioptions-=m
set guioptions-=T
set guioptions-=r

set foldmethod=manual
