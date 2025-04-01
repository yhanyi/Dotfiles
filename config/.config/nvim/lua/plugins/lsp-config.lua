return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
        }
      })
    end
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Show diagnostic explanation' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'List all diagnostics' })

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = false,
            }
          }
        }
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "/opt/homebrew/opt/llvm/bin/clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--query-driver=/opt/homebrew/opt/llvm/bin/clang++",
          "--compile-commands-dir=" .. vim.fn.expand("~/.cpp_compile_commands"),
          "--all-scopes-completion",
          "--pch-storage=memory"
        },
        root_dir = function(fname)
          local root = lspconfig.util.root_pattern(
            '.clangd',
            '.clang-tidy',
            '.clang-format',
            'compile_commands.json',
            'compile_flags.txt',
            'configure.ac',
            '.git'
          )(fname)
          if not root then
            return vim.fn.expand('~')
          end

          return root
        end,
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true
        },
      })

      lspconfig.cmake.setup({
        capabilities = capabilities,
        filetypes = { "CMakeLists.txt" },
        root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
      })

      lspconfig.pyright.setup({
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
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
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

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
