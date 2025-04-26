return {
  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          rust = { "rustfmt" },
          cpp = { "clang_format" },
          c = { "clang_format" },
          go = { "gofmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          markdown = { "prettier" },
        },

        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return {
            timeout_ms = 500,
            lsp_fallback = true,
          }
        end,
        formatexpr = true,
      })

      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          -- FormatToggle! will toggle the setting globally
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          print("Format on save globally " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
        else
          -- FormatToggle will toggle the setting for the current buffer
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          print("Format on save for current buffer " .. (vim.b.disable_autoformat and "disabled" or "enabled"))
        end
      end, { desc = "Toggle format on save", bang = true })

      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        conform.format({
          async = true,
          lsp_fallback = true,
        })
      end, { desc = "Format current buffer" })

      vim.keymap.set("n", "<leader>tf", function()
        vim.cmd("FormatToggle")
      end, { desc = "Toggle format on save for current buffer" })

      vim.keymap.set("n", "<leader>tF", function()
        vim.cmd("FormatToggle!")
      end, { desc = "Toggle format on save globally" })
    end,
  }
}
