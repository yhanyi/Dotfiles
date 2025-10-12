-- require("vim-options")
-- require("config.lazy")
vim.o.number = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.signcolumn = "yes"

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/m4xshen/autoclose.nvim" }
})

require("tokyonight").setup({})
vim.cmd("colorscheme tokyonight")

require('autoclose').setup()

require("oil").setup()
vim.keymap.set('n', '<C-n>', ':Oil --float<CR>')

vim.lsp.enable({ "lua_ls" })
vim.diagnostic.config({
	virtual_lines = true,
	-- virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

require('conform').setup({

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

-- vim.keymap.set({ "n", "v" }, "<leader>fm", function()
--   conform.format({
--     async = true,
--     lsp_fallback = true,
--   })
-- end, { desc = "Format current buffer" })

-- vim.keymap.set("n", "<leader>tf", function()
--   vim.cmd("FormatToggle")
-- end, { desc = "Toggle format on save for current buffer" })

-- vim.keymap.set("n", "<leader>tF", function()
--   vim.cmd("FormatToggle!")
-- end, { desc = "Toggle format on save globally" })
