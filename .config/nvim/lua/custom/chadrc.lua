---@type ChadrcConfig
local M = {}
M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")
M.ui = {
  theme = 'catppuccin',
  hl_override = {
    NvDashAscii = {
      fg = "cyan",
      bg = "none",
    },
  },
  nvdash = {
    load_on_startup = true,
    header = {
      "██╗  ██╗ █████╗ ███╗   ██╗    ██╗   ██╗██╗",
      "██║  ██║██╔══██╗████╗  ██║    ╚██╗ ██╔╝██║",
      "███████║███████║██╔██╗ ██║     ╚████╔╝ ██║",
      "██╔══██║██╔══██║██║╚██╗██║      ╚██╔╝  ██║",
      "██║  ██║██║  ██║██║ ╚████║       ██║   ██║",
      "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═╝   ╚═╝",
    }
  }
}

return M
