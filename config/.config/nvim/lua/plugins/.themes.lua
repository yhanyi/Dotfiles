return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        dim_inactive = false,
        lualine_bold = true,
        styles = {
          sidebars = "#1A1B26",
          floats = "#1A1B26",
        },
      })
      -- Dark
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --     local catppuccin = require('catppuccin')
  --     require("catppuccin").setup({})
  --   end,
  -- }
}
