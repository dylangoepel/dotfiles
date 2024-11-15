local utils = require('utils')

utils.setOpts({
    g = {
        mapleader = ' ',
        maplocalleader = '#',
        tex_flavor = 'latex',
        vimtex_view_general_viewer = 'zathura',
        vimtex_view_method = 'zathura',
        completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'},
        target_pane = "%1"
    },
    opt = {
        showmode = false,
        background = 'dark',
        showmatch = false,
        cursorline = true,
        autochdir = false,
        termguicolors = true,
        mouse = 'a',
        relativenumber = true,
        number = true,
        foldmethod = 'manual',
        completeopt = 'menuone,noinsert,noselect',
        scrolloff = 10,
        tabstop = 4,
        softtabstop = 4,
        expandtab = true,
        shiftwidth = 4,
        autoindent = true,
        smartindent = true,
    }
})

require('plugins') -- lazy.nvim
require('line') -- lualine

local function tmux_send_lines(lines)
    local text = string.gsub(table.concat(lines, "\n"), "'", "'\"'\"'") .. "\n"
    vim.fn.system("tmux send-keys -t " .. vim.g.target_pane .. " -l '" .. text .. "'")
end

utils.setKeymap({
    terminal = {
        jk = '<c-\\><c-n>',
    },
    insert = {
        jk = '<esc>',
    },
    normal = {
        ['<leader>'] = {
            ['<space>'] = '<c-^>',
            n = ':noh<cr>',
            l = {
                l = ':Lazy<cr>',
                m = ':Mason<cr>',
            },
            s = {
                e = ':enew<cr>',
                q = ':q!<cr>',
                t = ':term<cr>',
                f = '<c-w><c-w>:q!<cr>',
                d = ':cd %:p:h<cr>',
            },
            f = {
                c = ':e ~/.config/nvim/init.lua<cr>',
                n = ':e ~/.notes.md<cr>',
                o = ':e %:h/',
                ['+'] = ':let @+=@%<cr>',
            },
            r = {
                r = function() tmux_send_lines({ utils.buf_get_line() }) end,
                s = ':let g:target_pane="%"<left>' ,
            },
            d = {
                d = ':Dispatch<cr>',
                t = {
                    "Dispatch!",
                    onEvent = 'BufWritePost',
                },
                c = ':cclose<cr>',
                l = ':Copen<cr>',
                s = ':let b:dispatch = ""<left>',
            }
        }
    },
    visual = {
        ['<leader>r'] = function() tmux_send_lines(utils.buf_get_selection()) end,
    },
})

utils.perFiletype({
    ['*.tex'] = function()
        vim.b.dispatch = "latexmk -f- -CA -pdf " .. vim.fn.expand("%:p")
        utils.setKeymap({
            normal = {
                ["<leader>do"] = function()
                    vim.cmd(":Dispatch! zathura " .. vim.fn.expand("%:p:r") .. ".pdf")
                end,
            },
        })
    end,
    ['*.py'] = function()
        vim.b.dispatch = "python " .. vim.fn.expand("%:p")
    end,
    ['*.go'] = function()
        vim.b.dispatch = "go build"
    end,
    ['*.hs'] = function()
        vim.b.dispatch = "cabal build"
    end,
})


vim.cmd.colorscheme('tender')
