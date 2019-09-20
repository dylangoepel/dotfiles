" plugins
call plug#begin('~/.config/nvim/.plugged')
Plug 'neomake/neomake'
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
call plug#end()

let g:deoplete#enable_at_startup = 1
" look
set background=dark
set cursorline relativenumber number
colorscheme gruvbox

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
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

noremap <c-e> <c-o>:lnext<cr>

tnoremap jk <C-\><C-n>
inoremap jk <esc>
inoremap <esc> <nop>

inoremap <up> <nop>
inoremap <right> <nop>
inoremap <left> <nop>
inoremap <down> <nop>

nnoremap <C-l> :vert resize +1<cr>
nnoremap <C-h> :vert resize -1<cr>
nnoremap <C-j> :resize -1<cr>
nnoremap <C-k> :resize +1<cr>

" indentation
set autoindent expandtab shiftwidth=4 softtabstop=4

" filetype specific key bindings
augroup vimrc
    autocmd!
    au BufEnter *.py nnoremap <leader>r :! python3 %<cr>
    au BufEnter *.go nnoremap <leader>r :! go run .<cr>
    au BufEnter *.rs nnoremap <leader>r :! cargo run<cr>
    au BufEnter *.c nnoremap <leader>r :! gcc % -o /tmp/tempProgram && /tmp/tempProgram<cr>
    au BufWritePost * Neomake
augroup END
