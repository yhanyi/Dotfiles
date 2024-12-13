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

M.telescope = {
  n = {
    ["<leader>fn"] = { "<cmd>Telescope noice<cr>", "Find Noice Messages" },
    ["<leader>nd"] = { "<cmd>NoiceDismiss<cr>", "Dismiss Noice Messages" },
  }
}

return M
