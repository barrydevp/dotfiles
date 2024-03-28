return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        eslint_d = {},
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    opts = function()
      return {
        sources = {
          -- Diagnostics
          require("none-ls.diagnostics.eslint_d"),
          -- builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

          -- Code actions
          require("none-ls.code_actions.eslint_d"),
        },
        -- on_attach = lsp_core.on_attach,
        debounce = 150,
      }
    end,
  },
}
