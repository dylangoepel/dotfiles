local utils = require'utils'
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

    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.zenbones_darken_comments = 45
            vim.cmd.colorscheme('rosebones')
        end
    },

    { 'williamboman/mason.nvim', opts = {} },

    -- treesitter highlighting
    { 'kyazdani42/nvim-web-devicons', opts = {} },
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
    { 'hoob3rt/lualine.nvim' }, -- statusline

    { 'nvim-telescope/telescope.nvim', config = function()
        require'telescope'.setup{
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = {
                          require'telescope.actions'.move_selection_next, type = "action",
                          opts = { nowait = true, silent = true }
                        },
                        ["<C-k>"] = {
                          require'telescope.actions'.move_selection_previous, type = "action",
                          opts = { nowait = true, silent = true }
                        },
                    },
                },
            },
            pickers = {
                find_files = {
                    find_command = { "rg", "--ignore", "-L", "--files" },
                },
                live_grep = {
                    additional_args = function(_)
                        return {"-L", "--hidden"}
                    end,
                },
            },
        }
        local builtin = require'telescope.builtin'

        utils.setKeymap({
            normal = {
                ['<leader>'] = {
                    f = {
                        d = function() builtin.find_files({ cwd = utils.bufferDir() }) end,
                        f = builtin.find_files,
                        c = builtin.lsp_document_symbols,
                        s = builtin.lsp_workspace_symbols,
                        r = builtin.resume,
                        g = builtin.live_grep,
                        G = function() builtin.live_grep({
                            cwd = utils.bufferDir(),
                        }) end,
                        b = builtin.buffers,
                        e = builtin.diagnostics,
                    },
                },
            },
        })
    end},

    { 'stevearc/oil.nvim', opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
      default_file_explorer = true,
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = false,
      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = false,
      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,
      -- Oil will automatically delete hidden buffers after this delay
      -- You can set the delay to false to disable cleanup entirely
      -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = "editable",
      -- Set to true to watch the filesystem for changes and reload oil
      watch_for_changes = false,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          local m = name:match("^%.")
          return m ~= nil
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        -- Sort file names with numbers in a more intuitive order for humans.
        -- Can be "fast", true, or false. "fast" will turn it off for large directories.
        natural_order = "fast",
        -- Sort file and directory names case insensitive
        case_insensitive = false,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
        -- Customize the highlight group for the file name
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
          return nil
        end,
      },
      -- Extra arguments to pass to SCP when moving/copying files over SSH
      extra_scp_args = {},
      -- EXPERIMENTAL support for performing file operations with git
      git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
          return false
        end,
        mv = function(src_path, dest_path)
          return false
        end,
        rm = function(path)
          return false
        end,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      -- Configuration for the file preview window
      preview_win = {
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        preview_method = "fast_scratch",
        -- A function that returns true to disable preview on a file e.g. to avoid lag
        disable_preview = function(filename)
          return false
        end,
        -- Window-local options to use for preview window buffers
        win_options = {},
      },
      -- Configuration for the floating action confirmation window
      confirmation = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
        max_height = 0.9,
        -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating SSH window
      ssh = {
        border = "rounded",
      },
      -- Configuration for the floating keymaps help window
      keymaps_help = {
        border = "rounded",
      },
    } },

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
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ['<C-e>'] = cmp.mapping.abort(),
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

    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy", -- Or `LspAttach`
      priority = 1000, -- needs to be loaded in first
      config = function()
        require('tiny-inline-diagnostic').setup({
            preset = 'modern',
        })
      end,
    },
  },
  checker = { enabled = false },
})
