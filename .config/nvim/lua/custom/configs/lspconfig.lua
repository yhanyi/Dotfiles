local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities
local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup(
  {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"rust"},
    root_dir = lspconfig.util.root_pattern("Cargo.toml"),
  }
)

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm"
  },
  root_dir = lspconfig.util.root_pattern(
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git'
  ),
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true
  },
}

lspconfig.cmake.setup(
  {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"CMakeLists.txt"},
    root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
  }
)

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})
