set background=dark
colorscheme gruvbox

set cursorline relativenumber number

map <Space> <leader>
omap <Space> <Right>

let leader="ö"
nnoremap <leader>a :Gwrite<cr>
nnoremap <leader>u :Gpush<cr>
nnoremap <leader>l :Gpull<cr>
nnoremap <leader>L :Glog<cr>
nnoremap <leader>c :Gcommit<cr>
nnoremap <leader>g :Git 
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vplit $MYVIMRC<cr>

noremap <c-l> <c-o>:lnext<cr>

inoremap jk <esc>
inoremap <esc> <nop>

inoremap <up> <nop>
inoremap <right> <nop>
inoremap <left> <nop>
inoremap <down> <nop>

set autoindent expandtab shiftwidth=4 softtabstop=4
