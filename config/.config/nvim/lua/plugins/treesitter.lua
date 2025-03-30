return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "python",
          "java",
          "c",
          "cpp",
          "rust",
          "go",
          "bash",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        indent = {
          enable = true,
        }
      })
    end
  }
}
