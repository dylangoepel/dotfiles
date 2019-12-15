" plugins
call plug#begin('~/.config/nvim/.plugged')
Plug 'neomake/neomake'
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-rooter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

if &term == 'xterm-256color' || &term == 'screen-256color'
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[1 q"
endif

if exists('$TMUX')
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
endif

let g:rooter_silent_chdir = 1

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
nnoremap <Left> :tabprevious<cr>
nnoremap <Right> :tabnext<cr>
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-cr> :vsplit

nnoremap <C-f> :NERDTreeToggle<cr>


noremap <c-e> <c-o>:lnext<cr>

tnoremap jk <C-\><C-n>
inoremap jk <esc>
inoremap <esc> <nop>

inoremap <up> <nop>
inoremap <right> <nop>
inoremap <left> <nop>
inoremap <down> <nop>

nnoremap <S-l> :vert resize +5<cr>
nnoremap <S-h> :vert resize -5<cr>
nnoremap <S-j> :resize -5<cr>
nnoremap <S-k> :resize +5<cr>

" indentation
set autoindent expandtab shiftwidth=4 softtabstop=4

" filetype specific key bindings
augroup vimrc
    autocmd!
    au BufEnter *.py nnoremap <leader>r :! python3 %<cr>
    au BufEnter *.go nnoremap <leader>r :! go run .<cr>
    au BufEnter *.sh nnoremap <leader>r :! bash %
    au BufEnter *.rs nnoremap <leader>r :! cargo run<cr>
    au BufEnter *.c nnoremap <leader>r :! gcc % -o /tmp/tempProgram && /tmp/tempProgram<cr>
    au BufEnter *.go nnoremap <leader>f zfi{
    au BufEnter *.rs nnoremap <leader>f zfi{
    au BufEnter *.rs nnoremap <leader>f zfi{
    au BufWritePost * Neomake

    au BufEnter *.html nnoremap <leader>t yypli/<esc>
augroup END

set mouse=a
set guioptions-=m
set guioptions-=T
set guioptions-=r

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
