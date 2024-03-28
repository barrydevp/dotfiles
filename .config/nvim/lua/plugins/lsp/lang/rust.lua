return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        rust_analyzer = {},

        codelldb = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            {
              ["rust-analyzer"] = {
                -- ["rust-analyzer.cargo.target"] = "",
                ["rust-analyzer.checkOnSave.allTargets"] = false,
              },
            },
          },
        },
      },
    },
  },
}
