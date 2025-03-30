local neotree = require("neo-tree")

neotree.setup({})

vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>')
