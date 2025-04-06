return {
  {
    "romgrk/barbar.nvim",
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.g.barbar_auto_setup = false
      vim.keymap.set('n', '<C-S-1>', ':BufferGoto 1<CR>')
      vim.keymap.set('n', '<C-S-2>', ':BufferGoto 2<CR>')
      vim.keymap.set('n', '<C-S-3>', ':BufferGoto 3<CR>')
      vim.keymap.set('n', '<C-S-4>', ':BufferGoto 4<CR>')
      vim.keymap.set('n', '<C-S-5>', ':BufferGoto 5<CR>')
      vim.keymap.set('n', '<C-S-6>', ':BufferGoto 6<CR>')
      vim.keymap.set('n', '<C-S-7>', ':BufferGoto 7<CR>')
      vim.keymap.set('n', '<C-S-8>', ':BufferGoto 8<CR>')
      vim.keymap.set('n', '<C-S-9>', ':BufferGoto 9<CR>')
      local barbar = require("barbar")
      barbar.setup({
        sidebar_filetypes = {
          ["neo-tree"] = { text = "NeoTree", align = "center" }
        }
      })
    end
  }
}
