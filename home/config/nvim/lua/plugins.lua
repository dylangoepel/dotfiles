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

    { 'neovim/nvim-lspconfig', config = require'lsp'.config }, -- language server support

    { 'gpanders/nvim-parinfer' }, -- infer parentheses

    { 'williamboman/mason.nvim', opts = {} },

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

    -- aesthetics
    { 'jacoborus/tender.vim' },
    { 'hoob3rt/lualine.nvim' }, -- statusline

    { 'nvim-telescope/telescope.nvim', config = function()
        require'telescope'.setup{
            pickers = {
                find_files = {
                    find_command = { "rg", "--ignore", "-L", "--hidden", "--files" },
                },
            },
        }
        local builtin = require'telescope.builtin'
        require'utils'.setKeymap({
            normal = {
                ['<leader>'] = {
                    f = {
                        f = builtin.find_files,
                        d = function()
                            builtin.find_files({cwd=vim.fn.expand("%:p:h")})
                        end,
                        g = builtin.live_grep,
                        b = builtin.buffers,
                        e = builtin.diagnostics,
                    },
                },
            },
        })
    end},

    { 'aserowy/tmux.nvim', opts = {
        copy_sync = { enable = false, },
    } },

    -- autocompletion using nvim-cmp
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require'cmp'
            require'snippets'.register_cmp('snp')
            cmp.setup({
                snippet = {
                  expand = function(args)
                      vim.snippet.expand(args.body)
                  end,
                },
                mapping = cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  -- tab is handled by snippets.lua
                }),
                sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'snp' },
                  { name = 'buffer' },
                })
            })
            cmp.setup.cmdline({ '/', '?' }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = 'buffer' }
              }
            })
            cmp.setup.cmdline(':', {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = 'path' }
              }, {
                { name = 'cmdline' }
              }),
              matching = { disallow_symbol_nonprefix_matching = false }
            })
        end,
    },

    -- async :Make
    { 'tpope/vim-dispatch', },

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
