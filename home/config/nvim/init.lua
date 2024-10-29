local utils = require('utils')

utils.setOpts({
    g = {
        mapleader = ' ',
        maplocalleader = '#',
        loaded_netrw = 1,
        loaded_netrwPlugin = 1,
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

local function buf_get_line()
    return vim.api.nvim_buf_get_lines(0, vim.fn.getpos('.')[2] - 1, vim.fn.getpos('.')[2], true)[1]
end

local function buf_get_selection()
  local _, srow, scol = unpack(vim.fn.getpos('v'))
  local _, erow, ecol = unpack(vim.fn.getpos('.'))

  -- visual line mode
  if vim.fn.mode() == 'V' then
    if srow > erow then
      return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  end

  -- regular visual mode
  if vim.fn.mode() == 'v' then
    if srow < erow or (srow == erow and scol <= ecol) then
      return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  -- visual block mode
  if vim.fn.mode() == '\22' then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
      )
    end
    return lines
  end
end

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
            fc = ':e ~/.config/nvim/init.lua<cr>',
            r = {
                r = function() tmux_send_lines({ buf_get_line() }) end,
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
        ['<leader>r'] = function() tmux_send_lines(buf_get_selection()) end,
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
