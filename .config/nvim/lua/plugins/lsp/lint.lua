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
          -- builtins.diagnostics.eslint_d,
          -- builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

          -- Format
          -- builtins.formatting.prettierd.with {
          --   -- filetypes = { "html", "json", "markdown", "scss", "css" },
          --   prefer_local = "node_modules/.bin",
          -- },
          -- builtins.formatting.shfmt,
          -- builtins.formatting.stylua,
          -- builtins.formatting.autopep8,
          -- builtins.formatting.clang_format,

          -- Code actions
          -- builtins.code_actions.eslint_d,
          require("none-ls.code_actions.eslint_d"),
          require("null-ls").builtins.code_actions.gomodifytags,
          require("null-ls").builtins.code_actions.impl,
        },
        -- on_attach = lsp_core.on_attach,
        debounce = 150,
      }
    end,
  },
}
