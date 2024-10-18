local function setOpts(vals)
  local scopes = {opt = vim.opt, let = vim.g}
  for k, v in pairs(vals) do
      for kk, vv in pairs(v) do
          scopes[k][kk] = vv
      end
  end
end

setOpts({
    let = {
        mapleader = ' ',
        maplocalleader = '#',
        loaded_netrw = 1,
        loaded_netrwPlugin = 1,
        repl_filetype_commands = {
            python = 'ipython --no-autoindent',
            scheme = 'guile',
        },
        repl_split = 'right',
        tex_flavor = 'latex',
        vimtex_view_general_viewer = 'zathura',
        vimtex_view_method = 'zathura',
        completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'},
    },
    opt = {
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
    },
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { 'tpope/vim-repeat' }, -- remaps . to work with plugin commands
    { 'nvim-lua/plenary.nvim' }, -- functions missing from neovim

    { 'neovim/nvim-lspconfig' }, -- language server support

    { 'gpanders/nvim-parinfer' }, -- infer parentheses

    -- treesitter highlighting
    { 'kyazdani42/nvim-web-devicons' },
    { 'folke/lsp-colors.nvim' },
    { 'nvim-treesitter/nvim-treesitter', opts = {
      ensure_installed = {"c", "go", "haskell", "python", "rust", "scheme", "html", "javascript", "css", "bash", "lua", "markdown_inline"},
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]b"] = "@block.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["]B"] = "@block.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["[b"] = "@block.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["[B"] = "@block.outer",
        },
      },
      highlight = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = false,
          lookahead = false,

          keymaps = {
            ["ax"] = "@call.outer",
            ["ix"] = "@call.inner",
            ["af"] = "@class.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
          include_surrounding_whitespace = false,
        },
      },
    }},
    { 'nvim-treesitter/nvim-treesitter-textobjects' },

    -- error messages
    { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' }, -- inline (toggle with <space>D)

    -- aesthetics
    { 'jacoborus/tender.vim' },
    { 'hoob3rt/lualine.nvim' }, -- statusline

    -- fuzzy file finding (<space>f)
    { 'nvim-telescope/telescope.nvim' },

    -- file explorer
    { 'nvim-tree/nvim-tree.lua', opts = {} },

    { 'pappasam/nvim-repl' },

    { 'aserowy/tmux.nvim', opts = {} },

    -- autocompletion using nvim-cmp
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp',
        setup = function()
            require'cmp'.setup({
                snippet = {
                  expand = function(args)
                      vim.snippet.expand(args.body)
                  end,
                },
                mapping = require'cmp'.mapping.preset.insert({
                  ['<C-b>'] = require'cmp'.mapping.scroll_docs(-4),
                  ['<C-f>'] = require'cmp'.mapping.scroll_docs(4),
                  ['<C-Space>'] = require'cmp'.mapping.complete(),
                  ['<C-e>'] = require'cmp'.mapping.abort(),
                  ['<CR>'] = require'cmp'.mapping.confirm({ select = true }),
                  ['<Tab>'] = require'cmp'.mapping(function(fallback)
                    if vim.snippet.active({ direction = 1 }) then
                      vim.snippet.jump(1)
                    elseif require'cmp'.visible() then
                      require'cmp'.select_next_item()
                    else
                      fallback()
                    end
                  end, { 'i', 's' }),
                  ['<S-Tab>'] = require'cmp'.mapping(function(fallback)
                    if require'cmp'.visible() then
                      require'cmp'.select_prev_item()
                    elseif vim.snippet.active({ direction = -1 }) then
                      vim.snippet.jump(-1)
                    else
                      fallback()
                    end
                  end, { 'i', 's' }),
                }),
                sources = require'cmp'.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'snippets' },
                  { name = 'buffer' },
                  { name = 'path' },
                }, {
                  { name = 'buffer' },
                })
            })
        end,
    },

    -- async :Make
    { 'tpope/vim-dispatch' }, -- trigger with <space>m, toggle autocompile <space>M

    { 'garymjr/nvim-snippets', opts = {} },
    { 'dgagn/diagflow.nvim', opts = {
        enable = true,
        max_width = 80,  -- The maximum width of the diagnostic messages
        max_height = 20, -- the maximum height per diagnostics
        format = function(diagnostic)
          return diagnostic.message
        end,
        gap_size = 1,
        scope = 'line', -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
        padding_top = 0,
        padding_right = 0,
        text_align = 'left', -- 'left', 'right'
        placement = 'top', -- 'top', 'inline'
        inline_padding_left = 0, -- the padding left when the placement is inline
        toggle_event = { 'InsertEnter', 'InsertLeave' },
        update_event = { 'DiagnosticChanged', 'BufReadPost' },
        render_event = { 'DiagnosticChanged', 'CursorMoved' },
        show_borders = false,
    }}
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

Automake_id = {}
local function toggleAutocmd(c, event)
        return function()
            if Automake_id[c] == nil then
                local ret = vim.api.nvim_create_autocmd(event, {
                    callback = function()
                        vim.cmd(c)
                    end
                })
                Automake_id[c] = ret
            else
                vim.api.nvim_del_autocmd(Automake_id[c])
                Automake_id[c] = nil
            end
        end
end

local function setKeymap(map, opts)
    local modes = { normal = 'n', visual = 'v', terminal = 't', insert = 'i' }
    local keymapAll = function(f, mode, prefix, keys)
        for k, v in pairs(keys) do
            if type(v) == "table" then
                if v.onEvent ~= nil then
                    vim.keymap.set(mode, prefix .. k, toggleAutocmd(v[1], v.onEvent), opts)
                else
                    f(f, mode, prefix .. k, v)
                end
            else
                vim.keymap.set(mode, prefix .. k, v, opts)
            end
        end
    end
    for mode, keys in pairs(map) do
        keymapAll(keymapAll, modes[mode], '', keys)
    end
end

setKeymap({
    terminal = {
        jk = '<c-\\><c-n>',
    },
    insert = {
        jk = '<esc>',
    },
    visual = {
        r = '<Plug>ReplSendVisual',
    },
    normal = {
        ['<leader>'] = {
            sv = ':source $MYVIMRC<cr>',
            en = ':e ~/.notes',
            l = ':Lazy<cr>',
            r = {
                R = ':ReplToggle<cr>',
                q = ':ReplClose<cr>',
                c = ':ReplRunCell<cr>',
                l = ':ReplClear<cr>',
                r = '<Plug>ReplSendLine',
            },
            p = {
                s = '<cmd>ParinferOn<cr>',
                q = '<cmd>ParinferOff<cr>',
                m = ':Make<cr>',
            },
            f = {
                f = function() require'telescope.builtin'.find_files() end,
                g = function() require'telescope.builtin'.live_grep() end,
                b = function() require'telescope.builtin'.buffers() end,
                e = function() require'telescope.builtin'.diagnostics() end,
                c = ':e ~/.config/nvim/init.lua<cr>',
                F = ':NvimTreeFindFile<cr>',
            },
            d = {
                d = ':Dispatch<cr>',
                t = {
                    "Dispatch!",
                    onEvent = 'BufWritePost',
                },
                c = ':cclose<cr>',
                l = ':Copen<cr>',
                D = ':Start! kitty --detach --class floating --directory "%:p:h" <cr>',
                s = ':let b:dispatch = ""<left>',
            }
        }
    }
})

vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false }, virtual_text = false })

vim.cmd 'syntax enable'
vim.cmd 'colorscheme tender'
vim.cmd "iabbrev llambda λ"
vim.cmd "iabbrev ggamma Γ"
vim.cmd "iabbrev fforall ∀"
vim.cmd "iabbrev loz ◊"

local lspconfig = require'lspconfig'
local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
    hls = { filetypes = {'haskell', 'hs'} },
    rust_analyzer = { filetypes = {'rust', 'rs'} },
    gopls = { filetypes = {'go'}, root_dir = { "go.mod" } },
    pyright = { filetypes = {'python', 'py'} },
    clangd = { filetypes = {'c', 'h'} },
    racket_langserver = { filetypes = {'racket', 'scheme'} },
    ts_ls = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    svelte = { filetypes = { "svelte" } },
    texlab = { filetypes = { "tex" } },
    zls = { filetypes = { "zig", "zir" } },
    lua_ls = {
        settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = {'vim'},
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = {
                enable = false,
              },
            },
        }
    }
}

for lsp, settings in pairs(servers) do
    lspconfig[lsp].setup{
        filetypes = settings.filetypes,
        capabilities = default_capabilities,
        telemetry = { enable = false },
        cmd = settings.cmd,
        settings = settings.settings,
    }
end

function _G.toggle_diagnostics()
    if vim.g.diagnostics_active
    then
        vim.g.diagnostics_active = false
    else
        vim.g.diagnostics_active = true
    end
end

-- lsp-specific bindings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        underline = false,
        update_in_insert = false,
      }
    )

    setKeymap({
        normal = {
            ['<leader>'] = {
                g = {
                    D = vim.lsp.buf.declaration,
                    d = vim.lsp.buf.definition,
                    i = vim.lsp.buf.implementation,
                    r = vim.lsp.buf.references,
                },
                w = {
                    a = vim.lsp.buf.add_workspace_folder,
                    r = vim.lsp.buf.remove_workspace_folder,
                    l = function()
                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end,
                },
                c = {
                    r = vim.lsp.buf.rename,
                    c = function()
                        vim.lsp.buf.code_action({
                            apply = true,
                            filter = function(a)
                                return a.isPreferred
                            end,
                        })
                    end,
                },
                a = vim.lsp.buf.code_action,
                f = function()
                  vim.lsp.buf.format { async = true }
                end,
            }
        }
    }, {buffer = ev.buf})
  end,
})


require('line')
