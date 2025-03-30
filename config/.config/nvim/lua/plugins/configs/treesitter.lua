local treesitter = require("nvim-treesitter")

treesitter.setup({
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
