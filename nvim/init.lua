-- Han Yi's NeoVim Config.

-- Theme.
require("tokyonight").setup({})
-- require("tokyonight").setup({ style = "storm|moon|night|day" })
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

-- File navigation.
vim.g.netrw_banner = 0                  -- Disable netrw banner.
vim.keymap.set('n', '<C-n>', ':Ex<CR>', { desc = "Open file explorer" })
vim.keymap.set('n', '<leader>ff', ':find ', { desc = "Find file" })

-- Buffer navigation.
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>')
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>')

-- Tab navigation.
vim.opt.showtabline = 1                 -- Always show tabline.
vim.opt.tabline = ''                    -- Use default tabline.
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = "New tab" })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = "Close tab" })

-- Window navigation.
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

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
          return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
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
