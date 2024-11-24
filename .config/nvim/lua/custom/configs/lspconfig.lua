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

--- llspconfig.clangd.setup {
---   on_attach = function(client, bufnr)
---     client.server_capabilities.signatureHelpProvider = false
---     on_attach(client, bufnr)
---   end,
---   capabilities = capabilities,
---   cmd = {
---     "clangd",
---     "--background-index",
---     "--suggest-missing-includes",
---     "--clang-tidy",
---     "--header-insertion=iwyu",
---     "--completion-style=detailed",
---     "--function-arg-placeholders",
---     "--fallback-style=llvm",
---   },
---   init_options = {
---     usePlaceholders = true,
---     completeUnimported = true,
---     clangdFileStatus = true,
---   },
--- }
