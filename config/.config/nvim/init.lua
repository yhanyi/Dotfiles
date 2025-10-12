-- VIM OPTIONS
vim.wo.relativenumber = true
vim.o.number = true
vim.o.swapfile = false
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"

-- NATIVE PACKAGE MANAGER
vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/m4xshen/autoclose.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/vyfor/cord.nvim" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

-- TOKYONIGHT THEME
require("tokyonight").setup({})
vim.cmd.colorscheme("tokyonight")

-- BRACKET AUTOCLOSE
require('autoclose').setup()

-- OIL FILE EXPLORER
require("oil").setup()
vim.keymap.set('n', '<C-n>', ':Oil --float<CR>')

-- NATIVE LSP SERVER
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

-- CONFORM FORMATTER
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

-- BUFFERLINE --
vim.opt.termguicolors = true
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

-- DISCORD
local cord_handlers = {
  ["cpp"] = function(opts)
    return "Optimising " .. opts.filename
  end,
  ["rust"] = function(opts)
    return "Oxidising " .. opts.filename
  end,
  ["go"] = function(opts)
    return "Going " .. opts.filename
  end,
  ["python"] = function(opts)
    return "Snaking " .. opts.filename
  end,
}
require('cord').setup({
  usercmds = true,           -- Enable user commands
  log_level = 'error',       -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
  timer = {
    interval = 1500,         -- Interval between presence updates in milliseconds (min 500)
    reset_on_idle = false,   -- Reset start timestamp on idle
    reset_on_change = false, -- Reset start timestamp on presence change
  },
  editor = {
    image = nil,                          -- Image ID or URL in case a custom client id is provided
    client = 'neovim',                    -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
    tooltip = 'The Superior Text Editor', -- Text to display when hovering over the editor's image
  },
  display = {
    theme = "default",
    flavor = "accent",
    show_time = true,             -- Display start timestamp
    show_repository = true,       -- Display 'View repository' button linked to repository url, if any
    show_cursor_position = false, -- Display line and column number of cursor's position
    swap_fields = false,          -- If enabled, workspace is displayed first
    swap_icons = false,           -- If enabled, editor is displayed on the main image
    workspace_blacklist = {},     -- List of workspace names that will hide rich presence
  },
  lsp = {
    show_problem_count = true, -- Display number of diagnostics problems
    severity = 1,              -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
    scope = 'workspace',       -- buffer or workspace
  },
  idle = {
    enable = true, -- Enable idle status
    show_status = true, -- Display idle status, disable to hide the rich presence on idle
    timeout = 300000, -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
    disable_on_focus = false, -- Do not display idle status when neovim is focused
    text = 'Idle', -- Text to display when idle
    tooltip = '💤', -- Text to display when hovering over the idle image
  },
  text = {
    viewing = function(opts)
      return ('Viewing ' .. opts.filename)
    end,
    editing = function(opts)
      return cord_handlers[opts.filetype] and cord_handlers[opts.filetype](opts) or ('Editing ' .. opts.filename)
    end,
    file_browser = function(opts)
      return ('Browsing files in ' .. opts.workspace)
    end,
    workspace = function(opts)
      return ('In ' .. opts.workspace)
    end,
  },

  assets = {
    ['Cargo.toml'] = { text = 'Managing Cargo dependencies...' },
    ['CMakeLists.txt'] = { text = 'Configuring build system...' },
    ['Dockerfile'] = { text = 'Containerising applications...' },
    ['docker-compose.yml'] = { text = 'Orchestrating containers...' },
  },
})

-- DAP DEBUGGER
local dap, dapui = require('dap'), require('dapui')
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
vim.keymap.set('n', '<Leader>dt', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)

-- LUALINE
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
