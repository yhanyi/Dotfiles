local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add Breakpoint At Line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start/Continue Debugger",
    },
  }
}

return M
