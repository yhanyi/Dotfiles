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
  color = "Visual",
}

local searchcount = {
  "searchcount",
  color = "Search",
  -- fmt = function(s)
  --   if s == "" or s == "[0/0]" then
  --     return ""
  --   end
  --   local search_pattern = vim.fn.getreg("/")
  --   return "SEARCH: " .. search_pattern .. " " .. s
  -- end,
}

local selectioncount = {
  "selectioncount",
  color = "Visual",
}

local mode = { "mode" }

local location = { "location" }

local encoding = { "encoding" }

local filetype = { "filetype" }

local progress = { "progress" }

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local lualine = require('lualine')
      lualine.setup({
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
          lualine_x = {
            selectioncount,
            searchcount,
            macro,
          },
          lualine_y = { filetype, encoding },
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
    end
  }
}
