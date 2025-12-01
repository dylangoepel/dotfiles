local utils = require('utils')

utils.setOpts({
    g = {
        mapleader = ' ',
        maplocalleader = '#',
        tex_flavor = 'latex',
        vimtex_view_general_viewer = 'zathura',
        vimtex_view_method = 'zathura',
        completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' },
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
        foldmethod = 'marker',
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
require('line')    -- lualine

local function ltrim(s)
    return s:match '^%s*(.*)'
end

local function rtrim(s)
    return s:match '(.*)%s*$'
end

local function trim(s)
    return ltrim(rtrim(s))
end

local function tmux_send_lines(lines)
    local text = trim(string.gsub(table.concat(lines, "\n"), "'", "'\"'\"'")) .. "\n"

    vim.fn.system("tmux send-keys -t " .. vim.g.target_pane .. " -l '" .. text .. "'")
end

local function tmux_send_keys(keys)
    vim.fn.system("tmux send-keys -t " .. vim.g.target_pane .. " '" .. table.concat(keys, "' '") .. "'")
end

local function tmux_get_panes()
    local handle = io.popen("tmux list-panes")
    if handle == nil then
        return nil
    end
    local result = handle:read("*a")
    handle:close()

    local panes = {}
    while string.len(result) > 0 do
        local i = result:find("%%") or result:find(" ")
        if i == nil then
            vim.print("could not find %:", result)
            return nil
        end
        result = result:sub(i + 1)
        local j = result:find("\n")
        if j == nil then
            vim.print("could not find newline:", result)
            return nil
        end
        local jj = result:find(" ")
        if jj ~= nil then
            j = math.min(j, jj)
        end
        local m = tonumber(result:sub(0, j))
        if m == nil then
            vim.print("could not parse number:", result:sub(0, j))
            return nil
        end
        result = result:sub(j + 1)
        table.insert(panes, m)
    end

    return panes
end

local function tmux_get_newest_pane()
    local panes = tmux_get_panes()
    local n = 0
    for _, v in ipairs(panes) do
        n = math.max(n, v)
    end
    return n
end

utils.setKeymap({
    terminal = {
        jk = '<c-\\><c-n>',
    },
    insert = {
        jk = '<esc>',
    },
    normal = {
        ['-'] = ':e %:p:h/<cr>',
        ['<C-Enter>'] = function() vim.cmd('Dispatch! kitty --detach --directory ' .. utils.bufferDir()) end,
        ['<C-s>'] = ':w<cr>',
        ['<C-q>'] = ':q<cr>',
        ['<leader>'] = {
            ['<cr>'] = function()
                tmux_send_keys({'C-c'})
                tmux_send_keys({'Up', 'Enter'})
            end,
            ['<space>'] = '<c-^>',
            ['-'] = ':e ~/<cr>',
            n = ':noh<cr>',
            l = {
                l = ':Lazy<cr>',
                m = ':Mason<cr>',
            },
            y = {
                y = function() vim.cmd('let @+=@%') end,
                p = function() vim.cmd('let @+="' .. utils.bufferDir() .. '"') end,
            },
            r = {
                r = function() tmux_send_lines({ utils.buf_get_line() }) end,
                s = ':let g:target_pane="%"<left>',
                l = {
                    function()
                        return ':let g:target_pane="%' .. tmux_get_newest_pane() .. '"<cr>'
                    end,
                    opts = {
                        expr = true
                    },
                },
                x = function() tmux_send_lines({ vim.b.dispatch }) end,
                d = function() tmux_send_lines({ "cd " .. utils.bufferDir() }) end,
            },
            d = {
                d = ':Dispatch<cr>',
                ['<space>'] = ':Dispatch!<cr>',
                t = {
                    "Dispatch!",
                    onEvent = 'BufWritePost',
                },
                c = ':cclose<cr>',
                l = ':Copen<cr>',
                s = ':let b:dispatch = ""<left>',
            },
            f = {
                ['.'] = ':e $PWD/<cr>',
                ['r'] = ':e oil-ssh://pi.local//mnt/<cr>',
                C = ':e ~/.config/nvim/init.lua<cr>',
            }
        }
    },
    visual = {
        ['<leader>r'] = function() tmux_send_lines(utils.buf_get_selection()) end,
    },
})

utils.perFiletype({
    ['*.tex'] = function()
        vim.b.dispatch = "latexmk -f- -pdf " .. vim.fn.expand("%:p")
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
    ['*.md'] = function()
        vim.b.dispatch = "pandoc --template eisvogel -f gfm -t pdf " .. vim.fn.expand("%:p") .. " -o " .. vim.fn.expand("%:p:r") .. ".pdf"
        utils.setKeymap({
            normal = {
                ["<leader>do"] = function()
                    vim.cmd(":Dispatch! zathura " .. vim.fn.expand("%:p:r") .. ".pdf")
                end,
            },
        })
    end,
    ['*-compose.yaml'] = function()
        vim.b.dispatch = "docker-compose -f " .. vim.fn.expand("%:p") .. " build"
        utils.setKeymap({
            normal = {
                ["<leader>dU"] = function()
                    vim.cmd(":Dispatch! docker-compose -f " .. vim.fn.expand("%:p") .. " down")
                end,
                ["<leader>du"] = function()
                    vim.cmd(":Dispatch docker-compose -f " .. vim.fn.expand("%:p") .. " up")
                end,
            },
        })
    end,
    ['*.go'] = function()
        vim.b.dispatch = "go build -v"
    end,
    ['*.hs'] = function()
        vim.b.dispatch = "cabal build"
    end,
})
