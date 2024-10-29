local snippets = {}

snippets.g = {
    {trigger = 'shebang', body = '#!/bin sh'}
}

snippets.f = {
    lua = {
        { trigger = 'func', body = 'function $1($2)$0\nend' },
    },
    go = {
        { trigger = 'func', body = 'func ${1:main}($2) {$0\n}' },
        { trigger = 'httph', body = 'func ${1:handleHTTP}(w http.ResponseWriter, r *http.Request) {$0\n}' },
        { trigger = 'iferr', body = 'if err != nil {$0\n}' },
        { trigger = 'pkg', body = 'package $1\n\nimport ($2)\n\n$0' },
    },
    tex = {
        { trigger = 'rr', body = '\\mathbb{$1}', },
        { trigger = 'opr', body = '\\operatorname{$1}', },
        { trigger = 'eqq', body = '\\begin{align*}$0\n\\end{align*}' },
        { trigger = 'docpre', body = [[
\documentclass{article}
\usepackage[T1]{fontenc}
\usepackage[ngerman]{babel}
\usepackage[margin=2cm]{geometry}
\usepackage{enumerate}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{amsthm}
\usepackage{stmaryrd}
\usepackage{pdfpages}

\theoremstyle{plain}
\newtheorem*{theorem}{Satz}
\newtheorem{lemma}{Lemma}

\title{$1}
\author{$2}
\date{}
\begin{document}
\maketitle
$0
\end{document}
]]
        },
    },
}

function snippets.get_buf_snips()
    local ft = vim.bo.filetype
    local snips = vim.list_slice(snippets.g)

    if ft and snippets.f[ft] then
        vim.list_extend(snips, snippets.f[ft])
    end

    return snips
end

function snippets.register_cmp(name)
    local cmp_source = {}
    local cache = {}
    function cmp_source.complete(_, _, callback)
        local bufnr = vim.api.nvim_get_current_buf()
        if not cache[bufnr] then
            local completion_items = vim.tbl_map(function(s)
                ---@type lsp.CompletionItem
                local item = {
                    word = s.trigger,
                    label = s.trigger,
                    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
                    insertText = s.body,
                    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
                }
                return item
            end, snippets.get_buf_snips())

            cache[bufnr] = completion_items
        end

        callback(cache[bufnr])
    end

    require('cmp').register_source(name, cmp_source)
end

return snippets
