local Utils = require("utils")

return {
  {
    "stevearc/conform.nvim",
    -- event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>lf",
        Utils.lsp.format,
        { desc = "lsp formatting" },
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
        stop_after_first = true,
      },
    },
  },
}
