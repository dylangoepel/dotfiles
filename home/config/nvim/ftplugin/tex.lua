local utils = require'utils'
vim.keymap.set({'n'}, '<cr>', utils.markdownEnter, {buffer = true})
