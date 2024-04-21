return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        pyright = {},
        black = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        htmldjango = { "djhtml" },
      },

      formatters = {
        djhtml = {
          command = "djhtml",
          args = {
            "-",
          },
          stdin = true,
          require_cwd = false,
        },
      },
    },
  },

  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   dependencies = {
  --     "mfussenegger/nvim-dap-python",
  --     -- stylua: ignore
  --     keys = {
  --       { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
  --       { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  --     },
  --     config = function()
  --       local path = require("mason-registry").get_package("debugpy"):get_install_path()
  --       require("dap-python").setup(path .. "/venv/bin/python")
  --     end,
  --   },
  -- },
}
