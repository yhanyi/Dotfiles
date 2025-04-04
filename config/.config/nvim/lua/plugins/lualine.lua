local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  buffer_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) == 1
  end,
  screen_width = function(min_w)
    return function()
      return vim.o.columns > min_w
    end
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  diff_mode = function()
    return vim.o.diff == true
  end,
}

local branch = {
  "branch",
  icon = "",
  fmt = function(s)
    if #s == 0 then
      return ""
    end

    -- PERF: is it ok to run this on each render
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

local filename = {
  "filename",
  path = 4,
  shorting_target = vim.fn.winwidth(0) / 2,
  symbols = {
    modified = "●",
  },
  cond = conditions.buffer_not_empty,
}


local cwd = {
  function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
}

local separator = { "%=" }

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

local filetype = {
  "filetype",
  cond = conditions.screen_width(120),
}

local progress = { "progress" }

local colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fe8019',
  gray         = '#a89984',
  darkgray     = '#3c3836',
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
}

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = {
        normal = {
          a = "StatusLine",
          b = "StatusLine",
          c = "StatusLine",
          x = "StatusLine",
          y = "StatusLine",
          z = "StatusLine",
        },
        -- insert = {
        --   a = { bg = colors.blue, fg = colors.orange },
        --   b = "StatusLine",
        --   c = "StatusLine",
        --   x = "StatusLine",
        --   y = "StatusLine",
        --   z = "StatusLine",
        -- }
      },
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
      lualine_b = { cwd, branch, diff },
      lualine_c = { diagnostics },
      lualine_x = {
        selectioncount,
        searchcount,
        macro,
      },
      lualine_y = { filetype },
      lualine_z = { encoding, location, progress },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
