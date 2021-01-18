" required for vundle
set nocompatible
filetype off

set clipboard=unnamedplus

filetype plugin indent on
call plug#begin(stdpath('data') . '/plugged')
Plug 'neomake/neomake'
Plug 'leanprover/lean.vim'
Plug 'gryf/wombat256grf'
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips'
Plug 'KeitaNakamura/tex-conceal.vim'
call plug#end()

call neomake#configure#automake('w', 0)

" look
syntax on
set background=dark
set cursorline relativenumber number



" keybindings
let mapleader=","
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <C-l> :tabnext<cr>
nnoremap <C-h> :tabprev<cr>
nnoremap <leader>f :VsplitVifm<cr>
nnoremap <leader>m :make<cr>

nnoremap <leader>e :call fzf#run({'sink': 'e', 'source': 'git ls-files -co --exclude-standard'})<cr>

nnoremap <leader>tv :VimtexView<cr>
nnoremap <leader>tc :VimtexCompile<cr>

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

set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermbg=NONE
hi Conceal ctermfg=NONE
hi Conceal guifg=NONE
hi Conceal guibg=NONE

function OnLean()
    iabbrev -> →
    iabbrev <- ←
    iabbrev \| ∣
    iabbrev \< ⟨
    iabbrev \> ⟩
    iabbrev \ex "∃"
    iabbrev \all "∀"
    iabbrev \and "∧"
    iabbrev \or "∨"
    iabbrev \not "¬"
    iabbrev \R ℝ
    iabbrev \N ℕ
    iabbrev \Z ℤ
    iabbrev \1 ₁
    iabbrev \2 ₂
    iabbrev \3 ₃
    iabbrev \4 ₄
    iabbrev \5 ₅
    iabbrev \6 ₆
    iabbrev \7 ₇
    iabbrev \8 ₈
    iabbrev \9 ₉
    iabbrev \0 ₀
endfunction

au FileType *.lean call OnLean()
