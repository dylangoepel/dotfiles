local snippets = {}

snippets.g = {
    {trigger = 'shebang', body = '#!/bin sh'}
}

snippets.f = {
    lua = {
        { trigger = 'func', body = 'function $1($2)$0\nend' },
    },
    typescriptreact = {
        { trigger = 'compp', body = [[ 
type $1Props = {};
type $1State = {};
class $1 extends Component<$1Props, $1State> {
    constructor() {
        super();
        this.state = {};
    }

    render(props: Readonly<$1Props>, state: Readonly<$1State>) {
        return <>$0
        </>;
    }
}
]] },
        { trigger = 'tgs', body = '<$0 />' },
        { trigger = 'tgg', body = [[<$1$0>
</$1>]]},
        { trigger = 'inpt', body = '<input type="$1"$0 />' },
        { trigger = 'div', body = '<div$1>$0</div>' },
        { trigger = 'span', body = '<span$1>$0</span>' },
        { trigger = 'pp', body = '<p$1>$0</p>' }
    },
    go = {
        { trigger = 'hts', body = 'func ${1:handleHTTP}(w http.ResponseWriter, r *http.Request) {$0\n}' },
        { trigger = 'iferr', body = 'if err != nil {$0\n}' },
        { trigger = 'pkg', body = 'package $1\n\nimport ($0)\n' },
        { trigger = 'fpr', body = 'fmt.Fprintf(w, "$0")' },
        { trigger = 'lpr', body = 'log.Printf("$0")' },
        { trigger = 'whr', body = 'w.WriteHeader(http.Status$0)' },
    },
    tex = {
        { trigger = 'bb', body = '\\mathbb{$1}', },
        { trigger = 'begg', body = [[
\begin{$1}
    $0
\end{$1}
]], },
        { trigger = 'opr', body = '\\operatorname{$1}', },
        { trigger = 'sf', body = '\\mathsf{$1}', },
        { trigger = 'cal', body = '\\mathcal{$1}', },
        { trigger = 'leftt', body = '\\left$1$0\\right$1' },
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

snippets.f.markdown = snippets.f.tex;

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

function snippets.tab_action(n)
    local cmp = require'cmp'
    local selected_index = cmp.get_active_entry()
	if cmp.visible() then
        if n > 0 then
            if selected_index == nil then
                cmp.select_next_item()
                cmp.select_prev_item()
            elseif not cmp.select_next_item() then
                    cmp.confirm()
            end
        elseif not cmp.select_prev_item() then
            cmp.confirm()
        end
    elseif vim.snippet.active({direction = n}) then
        vim.snippet.jump(n)
	else
        if n > 0 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'in', false)
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), 'in', false)
        end
	end
end

vim.keymap.set("i", "<Tab>", function() snippets.tab_action(1) end)
vim.keymap.set("i", "<S-Tab>", function() snippets.tab_action(-1) end)

return snippets
