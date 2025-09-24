local Utils = require("utils")
vim.g.zig_fmt_autosave = 0

return {
  recommended = function()
    return Utils.extras.wants {
      ft = { "zig", "zir" },
      root = { "zls.json", "build.zig" },
    }
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "zig" } },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "zls",
          },
        },
      },
    },
    opts = {
      servers = {
        zls = {},
      },
    },
  },

  -- {
  --   "stevearc/conform.nvim",
  --   dependencies = {
  --     {
  --       "mason-org/mason.nvim",
  --       opts = {
  --         ensure_installed = {
  --           "zigfmt",
  --         },
  --       },
  --     },
  --   },
  --   opts = {
  --     formatters_by_ft = {
  --       zig = { "zigfmt" },
  --     },
  --   },
  -- },
}
