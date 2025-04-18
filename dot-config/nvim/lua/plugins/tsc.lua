return {
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    ft = { "typescript", "typescriptreact" },
    config = {
      auto_open_qflist = false,
    },
    keys = { { "<leader>ct", "<cmd>TSC<cr>", desc = "Type-check" } },
  },
}
