local lsp = {}


-- :MasonInstall haskell-language-server gopls pyright clangd typescript-language-server texlab zls lua-language-server

function lsp.config()
    local lspconfig = require'lspconfig'
    local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
    require'mason-lspconfig'.setup_handlers{
        function(name)
            lspconfig[name].setup{
                capabilities = default_capabilities
            }
        end,
    }

    -- lsp-specific bindings
    vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false }, virtual_text = false })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
            signs = true,
            underline = false,
            update_in_insert = false,
          }
        )

        require'utils'.setKeymap({
            normal = {
                ['<leader>'] = {
                    g = {
                        D = vim.lsp.buf.declaration,
                        d = vim.lsp.buf.definition,
                        i = vim.lsp.buf.implementation,
                        r = vim.lsp.buf.references,
                        h = vim.lsp.buf.hover,
                        H = vim.lsp.buf.signature_help,
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
end

vim.diagnostic.config({
  signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
  },
})

return lsp
