vim.cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq {'savq/paq-nvim', opt = true}
paq {'joom/latex-unicoder.vim'}
paq {'morhetz/gruvbox'}
paq {'leanprover/lean.vim'}
paq {'lervag/vimtex'}
paq {'SirVer/ultisnips'}
paq {'neovim/nvim-lspconfig'}
paq {'nvim-lua/completion-nvim'}

-- stolen from https://oroques.dev/notes/neovim-init
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ','
vim.g['gruvbox_contrast_dark'] = 'hard'
vim.g['gruvbox_invert_selection'] = '0'

vim.cmd 'colorscheme gruvbox'
vim.cmd 'syntax on'

opt('o', 'background', 'dark')
opt('w', 'cursorline', true)
opt('w', 'relativenumber', true)
opt('w', 'number', true)

map('', '<leader>sv', ':source $MYVIMRC<cr>')
map('', '<leader>ev', ':e $MYVIMRC<cr>')
map('', '<C-l>', ':tabnext<cr>')
map('', '<C-h>', ':tabprev<cr>')
map('', '<leader>f', ':VsplitVifm<cr>')
map('', '<leader>m', ':make<cr>')
map('', '<leader>m', ':make<cr>')
map('', '<leader>e', ":call fzf#run({sink = 'e', source = 'git ls-files -co --exclude-standard'})<cr>")
map('', '<leader>tv', ':VimtexView<cr>')
map('', '<leader>tc', ':VimtexCompile<cr>')
map('', '<leader>ne', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
map('', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
map('', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
map('', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
map('', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
map('', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
map('', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>')
map('i', 'jk', '<esc>')
opt('b' , 'autoindent', true)
opt('b' , 'expandtab', true)
opt('b' , 'shiftwidth', 4)
opt('b' , 'softtabstop', 4)
opt('b', 'smartindent', true)
opt('o', 'mouse', 'a')
opt('w', 'foldmethod', 'manual')
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_view_method = 'zathura'
opt('w', 'scrolloff', 10)
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
vim.g.UltiSnipsEditSplit = 'vertical'

vim.cmd "highlight LspDiagnosticsDefaultError guifg='BrightRed'"

local lspconfig = require'lspconfig'
local function setupLanguageServer(name, cmd)
    lspconfig[name].setup{on_attach=require'completion'.on_attach, cmd=cmd, root_dir = lspconfig.util.root_pattern(".git")}
end

setupLanguageServer('pyright', nil)
setupLanguageServer('rls', nil)
setupLanguageServer('leanls', {'lean', '--server'})
setupLanguageServer('clangd', nil)
setupLanguageServer('hls', nil)
setupLanguageServer('gopls', nil)

opt('o', 'completeopt', 'menuone,noinsert,noselect')
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
