-- Han Yi's NeoVim Config.

-- Plugins.
vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/goolord/alpha-nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
})

-- Theme.
require("tokyonight").setup({})
vim.cmd.colorscheme("tokyonight")
vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "None" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "None" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "None" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })

-- Basic.
vim.opt.number = true                   -- Show line numbers.
vim.wo.relativenumber = true            -- Show relative line numbers.
vim.opt.cursorline = true               -- Highlight current line.
vim.opt.wrap = false                    -- Wrap lines.
vim.opt.swapfile = false                -- Do not create swapfiles.

-- Indentation.
vim.opt.tabstop = 2                     -- Tab width.
vim.opt.shiftwidth = 2                  -- Indent width.
vim.opt.softtabstop = 2                 -- Soft tab stop.
vim.o.expandtab = true                  -- Use spaces instead of tabs.
vim.opt.smartindent = true              -- Smart auto-indenting.
vim.opt.autoindent = true               -- Copy indent from current line.

-- Search.
vim.opt.ignorecase = true               -- Case insensitive search.
vim.opt.smartcase = true                -- Case sensitive if uppercase in search.
vim.opt.hlsearch = false                -- Do not highlight search results.
vim.opt.incsearch = true                -- Show matches while typing.

-- Behaviour.
vim.opt.mouse = "a"                     -- Enable mouse support.
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard.
vim.opt.autocomplete = true             -- Enable autocomplete.
vim.opt.completeopt = { "menuone", "noinsert", "noselect" } -- Completion options.
vim.opt.encoding = "UTF-8"              -- Set encoding.
vim.opt.modifiable = true               -- Allow buffer modifications.
vim.opt.showmatch = true                -- Highlight matching brackets.
vim.opt.cmdheight = 1                   -- Command line height.
vim.opt.backspace = { "indent", "eol", "start" } -- Better backspace behaviour.

-- Visual.
vim.opt.termguicolors = true            -- Enable 24-bit colours.
vim.opt.signcolumn = "yes"              -- Show sign column.

-- Mapping.
vim.g.mapleader = " "                   -- Set leader key to space.
vim.g.maplocalleader = " "              -- Set local leader key.

-- Dashboard.
local alpha, dashboard = require('alpha'), require('alpha.themes.dashboard')
local logo = {
  "⡿⢋⣠⠆⠀⠃⠅⠄⡴⢿⣿⣿⣿⣿⣿⣿⡿⠯⡉⠐⠪⣄⠀⠹⣆⢳⣶⣍⡻⣦⠈⠰⣄⡀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⣨⣄⠚⠀⠈⣴⠀⣰⣿⣿⣿⣿⣿⣷⣶⣥⣀⠛⠷⣮⣄⠁⡀⠘⢦⠙⢿⣿⣮⡀⠀⠙⠿⠦⢢⠀⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣼⣟⠅⠈⠀⠀⠘⣇⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⡑⢝⢦⡀⠈⢧⢳⡜⣿⣿⣆⠀⠀⠀⠀⠀⠈⠙⠛⠻⠿⠿⢿⣿⣿⣟⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣃⡔⡁⠁⠀⠀⠹⡎⢮⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⢀⠀⠙⡄⠈⢇⠻⡜⣿⣿⣷⡀⢄⠀⠀⡀⠀⠀⠤⠐⢂⠀⣀⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣾⣿⣆⡅⢠⡦⢣⢠⠹⡔⣭⣛⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣧⡹⣄⠊⠀⠈⡎⢔⢹⣿⣿⣿⡆⠳⠀⠢⡉⠱⣖⠩⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣻⣿⣿⣧⠸⣆⠆⢀⢂⡘⡜⣿⣿⣿⣿⣿⡿⢿⣻⠓⡀⠻⢏⠟⡜⣆⡅⠀⠸⡀⠊⢻⣿⣿⣿⡆⠀⠀⠘⣦⡀⠙⠶⣭⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⣿⣿⢀⠙⠸⠄⠀⢳⡙⢜⣻⣡⣌⢿⡙⣆⡻⢷⡷⡡⢘⠣⡪⠘⣿⡄⠀⢃⠎⢄⢿⣿⣿⣿⡄⠀⠀⡈⣿⠇⡴⠀⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⣿⠏⡄⠄⣧⣴⢠⠠⠊⡎⠻⢛⣬⡊⢿⡄⣿⣷⡌⡀⢆⠀⢁⠡⢹⣿⡄⠘⡸⠈⡜⣿⣿⣿⣿⠄⠀⠀⢸⠀⠇⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⠣⡆⡇⠀⠻⠸⢀⢵⡀⠙⣶⡕⠙⢿⣿⣿⣾⣿⣿⡆⠘⡄⢢⡌⠜⡝⣷⡀⠇⡇⢠⢻⣿⣿⣿⡈⠀⠡⢰⡄⢀⡄⢷⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⢰⢱⠳⠀⢀⣷⠈⡜⣧⡠⡈⠻⣮⡪⡻⣿⣿⣿⣿⣿⠀⡇⠂⡇⡎⠐⠘⢇⢸⢀⠀⢸⣿⣿⣿⡇⠠⠀⠼⠁⣼⠁⠘⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⠘⡿⡸⡱⠈⣿⡄⠸⡜⠳⡙⠦⡈⠻⣬⡢⢝⠿⣿⣿⡇⢙⡀⢡⢲⣆⠀⠈⠈⠘⠸⡇⣿⣿⣿⣧⠀⠀⡇⢰⠏⠈⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⠀⢁⢧⠃⢃⢹⣷⠀⠻⣆⠙⣤⢹⡕⣤⣙⠻⠿⡟⣡⠂⡀⢡⡆⠗⠎⠃⠀⠀⢀⠀⠇⣿⣿⣿⣿⠀⢰⠀⢠⠄⠃⢺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⢿⣿⠃⠂⠈⡆⡐⢢⠩⣄⠀⠘⣦⡈⢿⣿⣮⣿⣿⣿⡇⡟⠀⠁⠀⠀⠀⠀⠀⡀⠀⠘⠀⢀⣿⣿⣿⣿⠀⡎⠀⠌⠘⣀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⡊⠻⡱⡁⠀⠀⠀⠈⢶⡙⢆⠀⠈⢿⣦⡁⡙⢿⣿⣿⠱⠁⠀⠀⠀⠀⠀⠀⠀⢁⠀⡄⠁⠘⢫⡿⣟⣿⠀⠀⣇⠔⢀⡜⡀⡀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣷⡠⠀⠚⠃⠁⠀⠀⠀⠉⠑⠁⠀⢁⠈⠻⠾⠄⣬⣅⠈⢀⡵⠀⠠⠗⢓⣀⣰⡿⠀⡇⢀⢡⡿⢰⢸⡃⠰⠀⠆⢠⢸⡆⢱⢹⣦⣈⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⢤⣀⠀⢴⡿⣄⠀⠀⠀⢀⠀⠄⠐⣝⠳⠶⠄⣁⣙⣤⣼⠿⠛⠛⠉⡜⠁⠆⡄⡸⢃⢂⡞⢁⡏⡄⡇⠀⢰⢠⣿⡰⡙⣏⢮⣛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠢⠈⠙⠶⣦⠌⢛⣃⣠⣘⣉⣶⣶⣶⣿⣿⡖⣿⣟⣭⣼⣷⣶⣶⣦⣦⣡⣇⡸⠀⠁⢁⠞⡐⡼⡰⣰⠃⢀⠇⣿⣿⣧⢹⢃⠷⣝⡻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⡧⡀⠂⠢⠐⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢩⢻⣿⣿⣿⣿⣿⣿⣿⣿⡄⢡⣞⠁⡁⡰⣰⡵⢣⠛⠠⠐⣼⣿⣿⡷⡡⡑⡑⢶⣭⣥⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⡆⠀⢕⠂⠄⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠰⡏⢗⣽⣿⣿⣿⣿⣿⣿⣿⡇⢈⡔⡄⠀⢡⡿⡡⠋⠆⠀⡜⣿⣿⣿⣤⠱⣝⢌⢶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⢿⣦⡀⠀⠊⠑⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣿⣿⣿⣿⠿⠟⢉⣿⡏⣴⢟⡼⠡⣠⣿⡗⢳⡌⡠⡾⣣⣾⣿⢿⠇⠐⢽⣧⡝⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⢿⣯⡇⠢⢀⠈⠻⢷⣜⠻⣿⣿⣿⣿⣿⠻⠿⠿⠛⢛⠉⡕⣠⣾⣿⣿⣿⢋⠞⠁⢀⠼⢟⠌⡞⣸⡿⢿⣿⣿⡿⡜⠐⢸⣄⢌⠻⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠈⠁⠀⠀⠀⠀⠉⠉⠙⠒⠉⠛⠿⣿⣿⣷⡘⡼⠘⠄⣴⣿⣿⣿⡿⡑⣡⠔⢠⠟⣵⠊⢨⠃⠟⣬⣿⣡⡟⡡⠀⠆⣬⢶⢊⢣⡹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠑⠀⠊⠼⣿⣿⡿⠋⢈⠾⠋⢀⡤⠞⣡⠎⡞⢰⠞⠋⢋⣿⣾⠃⠌⢠⣽⣆⢝⢿⣿⡜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠠⠄⢀⡈⠁⠁⠈⠉⠉⠁⠛⠒⠀⢀⡀⠀⠀⠀⠀⠀⠈⠀⠂⠀⠄⣒⣒⢍⠕⠀⡾⠃⠀⡇⠀⣴⣵⣿⣿⠃⠊⣰⣟⢻⣿⣮⣦⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠀⠀⠉⠣⢀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠢⢀⠀⠀⣤⠀⡀⠀⠀⠀⡄⠔⡥⠐⡱⠁⠀⢀⡷⢛⣿⠟⠁⡎⡠⣺⣿⡘⠯⡯⣿⣿⣿⣎⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠀⠀⠀⠀⠀⠙⠆⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠈⠀⠚⠁⣀⠌⠀⠀⠀⠐⠀⠀⡠⡀⠱⠊⠀⠀⠊⠀⠁⡙⠜⢇⠐⢬⣊⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠡⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠰⠁⡐⠑⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠈⠣⢪⣛⣿⣦⣍⣛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠈⠀⠁⠐⠀⣀⣁⠀⠀⣀⠀⠀⠀⠂⠀⠀⠈⠢⣄⠨⠭⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⢾⣿⡄⠉⢳⡄⡀⠐⢶⣅⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
}
dashboard.section.header.val = logo
dashboard.section.buttons.val = {}
dashboard.config.layout = {
  { type = "padding", val = 15 },
  dashboard.section.header,
  { type = "padding", val = 15 },
}
alpha.setup(dashboard.opts)

-- Oil file explorer.
require("oil").setup()
vim.keymap.set('n', '<C-n>', ':Oil --float<CR>')

-- Gitsigns.
require('gitsigns').setup()
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})

-- Window navigation.
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- BUFFERLINE --
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>')
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>')
require('bufferline').setup({
  options = {
    mode = 'buffers', -- set to "tabs" to only show tabpages instead
    themable = true,  -- allows highlight groups to be overriden i.e. sets highlights as default
    numbers = 'none', -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    buffer_close_icon = '✗',
    close_icon = '✗',
    path_components = 1, -- Show only the file name without the directory
    modified_icon = '●',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 30,
    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
    tab_size = 20,
    diagnostics = false,
    diagnostics_update_in_insert = false,
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = { '│', '│' }, -- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = true,
    always_show_bufferline = true,
    show_tab_indicators = false,
    indicator = {
      -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
      style = 'none', -- Options: 'icon', 'underline', 'none'
    },
    icon_pinned = '󰐃',
    -- minimum_padding = 1,
    -- maximum_padding = 5,
    -- maximum_length = 15,
    sort_by = 'insert_at_end',
    custom_filter = function(buf_number, buf_numbers)
      return vim.fn.bufname(buf_number) ~= ''
    end
  },
  highlights = {
    separator = {
      fg = '#434C5E',
    },
    buffer_selected = {
      bold = true,
      italic = false,
    },
    -- separator_selected = {},
    -- tab_selected = {},
    -- background = {},
    -- indicator_selected = {},
    -- fill = {},
  },
})

-- Floating terminal.
local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

vim.keymap.set("t", "<Esc>",
  function()
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
      vim.api.nvim_win_close(terminal_state.win, false)
      terminal_state.is_open = false
    end
  end,
  { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

vim.keymap.set("n", "<leader>t",
  function()
    -- Close terminal if it is already open.
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
      vim.api.nvim_win_close(terminal_state.win, false)
      terminal_state.is_open = false
      return
    end
    -- Create buffer if invalid or non-existent.
    if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
      terminal_state.buf = vim.api.nvim_create_buf(false, true)
      -- Set buffer options.
      vim.bo[terminal_state.buf].bufhidden = 'hide'
    end
    -- Calculate window dimensions.
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    -- Create the floating window.
    terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
    -- Set transparency for the floating window.
    vim.wo[terminal_state.win].winblend = 0
    vim.wo[terminal_state.win].winhighlight = 'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder'
    -- Define highlight groups for transparency.
    vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })
    -- Start terminal if not already running.
    local has_terminal = false
    local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
    for _, line in ipairs(lines) do
      if line ~= "" then
        has_terminal = true
        break
      end
    end
    if not has_terminal then
      vim.fn.termopen(os.getenv("SHELL"))
    end
    terminal_state.is_open = true
    vim.cmd("startinsert")
    -- Set up auto-close on buffer leave.
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = terminal_state.buf,
      callback = function()
        if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
          vim.api.nvim_win_close(terminal_state.win, false)
          terminal_state.is_open = false
        end
      end,
      once = true
    })
  end,
  { noremap = true, silent = true, desc = "Toggle floating terminal" })

-- Treesitter.
require('nvim-treesitter').setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "python",
    "cpp",
    "rust",
    "c",
    "java",
    "typst",
    "typescript",
    "javascript",
    "bash",
    "markdown",
    "markdown_inline",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  }
})

-- Telescope.
require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },
  pickers = {},
  extensions = {
    "themes",
    "terms",
    "noice",
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {}
    }
  },
})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Find text' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Find help' })

-- Dap Debugger.
local dap, dapui = require('dap'), require('dapui')
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
vim.keymap.set('n', '<Leader>dt', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)

-- Lualine.
local colours = {
  black  = '#080808',
  white  = '#ebdbb2',
  red    = '#dc4a4c',
  green  = '#9ece69',
  yellow = '#fe8019',
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  teal   = '#6dcbbd',
  violet = '#bb9af7',
}

local theme = {
  normal = {},
  insert = { a = { bg = colours.teal, fg = colours.black }, b = "StatusLine" },
  visual = { a = { bg = colours.violet, fg = colours.black }, b = "StatusLine" },
  replace = { a = { bg = colours.red, fg = colours.black }, b = "StatusLine" },
  inactive = {},
}

local branch = {
  "branch",
  icon = "",
  fmt = function(s)
    if #s == 0 then
      return ""
    end

    local h = vim.api.nvim_get_hl(0, {
      name = "StatusLine",
    })
    vim.api.nvim_set_hl(0, "LualineBranch", {
      bold = true,
      bg = h.bg,
      fg = h.fg,
    })
    return "%#LualineBranch#" .. s
  end,
}

local diff = {
  "diff",
  -- symbols = { added = " ", modified = " ", removed = " " },
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
}

local cwd = {
  function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
}

local macro = {
  function()
    local char_register = vim.fn.reg_recording()
    if #char_register > 0 then
      return "[REC @" .. char_register .. "]"
    end
    return ""
  end,
}

local mode = { "mode" }

local location = { "location" }

local encoding = { "encoding" }

local filetype = { "filetype" }

local progress = { "progress" }
require('lualine').setup({
  options = {
    theme = theme,
    globalstatus = true,
    always_divide_middle = false,
    component_separators = "",
    section_separators = "",
    disabled_filetypes = {
      statusline = { "neo-tree", "git", "fugitive", "toggleterm", "trouble" },
      winbar = { "neo-tree", "DiffviewFiles", "git" },
    },
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { cwd, branch },
    lualine_c = { diff, diagnostics },
    lualine_x = {},
    lualine_y = { macro, filetype, encoding },
    lualine_z = { location, progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})

-- Functions.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Enable yanking over ssh on OSC52-compatible terminal client',
  callback = function()
    local copy_to_unnamedplus = require('vim.ui.clipboard.osc52').copy '+'
    copy_to_unnamedplus(vim.v.event.regcontents)
    local copy_to_unnamed = require('vim.ui.clipboard.osc52').copy '*'
    copy_to_unnamed(vim.v.event.regcontents)
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor to file position in previous editing session",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- Defer centering slightly so it is applied after render.
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- Only act when entering an unnamed/empty buffer (the placeholder after deletion)
    local name = vim.api.nvim_buf_get_name(0)
    if name ~= "" then return end

    -- Collect all real buffers (named or modified)
    local real_bufs = vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_valid(buf)
        and (vim.api.nvim_buf_get_name(buf) ~= ""
             or vim.bo[buf].modified)
    end, vim.api.nvim_list_bufs())

    if #real_bufs == 0 then
      vim.schedule(function()
        vim.cmd("silent! alpha")
      end)
    end
  end,
})

-- Language Server Protocol.
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
vim.lsp.enable({ "clangd", "rust_analyzer", "cmake", "pyright", "tinymist", "lua_ls" })

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'cuda' },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git',
  },
  get_language_id = function(_, ftype)
    local t = { objc = 'objective-c', objcpp = 'objective-cpp', cuda = 'cuda-cpp' }
    return t[ftype] or ftype
  end,
  capabilities = {
    textDocumet = {
      completion = {
        editsNearCusor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true
  },
  on_init = function(client, init_result)
    if init_result.offsetEncoding then
      client.offsetEncoding = init_result.offsetEncoding
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(
      bufnr,
      'LspClangdSwitchSourceHeader',
      function()
        local method_name = 'textDocument/switchSourceHeader'
        ---@diagnostic disable-next-line:param-type-mismatch
        if not client or not client:supports_method(method_name) then
          return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(
            method_name))
        end
        local params = vim.lsp.util.make_text_document_params(bufnr)
        ---@diagnostic disable-next-line:param-type-mismatch
        client:request(method_name, params, function(err, result)
          if err then
            error(tostring(err))
          end
          if not result then
            vim.notify('corresponding file cannot be determined')
            return
          end
          vim.cmd.edit(vim.uri_to_fname(result))
        end, bufnr)
      end,
      { desc = "Switch between source and header" }
    )

    vim.api.nvim_buf_create_user_command(
      bufnr,
      'LspClangdShowSymbolInfo',
      function()
        local method_name = 'textDocument/symbolInfo'
        ---@diagnostic disable-next-line:param-type-mismatch
        if not client or not client:supports_method(method_name) then
          return vim.notify('Clangd client not found', vim.log.levels.ERROR)
        end
        local win = vim.api.nvim_get_current_win()
        local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
        ---@diagnostic disable-next-line:param-type-mismatch
        client:request(method_name, params, function(err, res)
          if err or #res == 0 then
            -- Clangd always returns an error, there is no reason to parse it
            return
          end
          local container = string.format('container: %s', res[1].containerName) ---@type string
          local name = string.format('name: %s', res[1].name) ---@type string
          vim.lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            title = 'Symbol Info',
          })
        end, bufnr)
      end,
      { desc = "Show symbol info" }
    )
  end,
})

vim.lsp.config('cmake', {
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
  root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
  init_options = {
    buildDirectory = 'build',
  },
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  settings = {
    ['rust_analyzer'] = {
      diagnostics = {
        enable = true
      }
    }
  }
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      }
    }
  }
})

vim.lsp.config('tinymist', {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  root_markers = { '.git' }
})

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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', 'df', vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = "Format local buffer" })
