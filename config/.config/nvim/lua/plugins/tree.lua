return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = function()
      local tree = require("neo-tree")
      tree.setup({
        window = {
          position = "float"
          -- position = "left"
        },
      })
      vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>')
    end
  },
}
