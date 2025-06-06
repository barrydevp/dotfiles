return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        ["eslint-lsp"] = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },
}
