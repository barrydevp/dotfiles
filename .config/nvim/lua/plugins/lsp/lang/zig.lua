vim.g.zig_fmt_autosave = 0

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        zls = {},

        zigfmt = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {},
      },
    },
  },
}
