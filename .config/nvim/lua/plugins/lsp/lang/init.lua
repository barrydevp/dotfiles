return {

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lang-servers
        vls = {},
        html = {},
        cssls = {},
        bashls = {},

        -- formatters
        prettier = {},
        shfmt = {},
        isort = {},

        -- linters
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        bib = { "bibclean" },
        tex = { "latexindent" },
        -- Use a sub-list to run only the first available formatter
        json = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        handlebars = { "prettier" },
        less = { "prettier" },
        yaml = { "prettier" },
        graphql = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        sh = { "shfmt" },
      },

      formatters = {
        injected = { options = { ignore_errors = true } },
        bibclean = {
          command = "bibclean",
          args = {
            "-align-equals",
            "-delete-empty-values",
          },
          stdin = true,
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    -- language servers with default setup
    opts = {
      servers = {
        vls = {},
        html = {},
        cssls = {},
        bashls = {},
      },
    },
  },

  -- other language servers
  { import = "plugins.lsp.lang.lua_ls" },
  { import = "plugins.lsp.lang.clangd" },
  { import = "plugins.lsp.lang.go" },
  { import = "plugins.lsp.lang.rust" },
  { import = "plugins.lsp.lang.typescript" },
  { import = "plugins.lsp.lang.eslint" },
  { import = "plugins.lsp.lang.java" },
  { import = "plugins.lsp.lang.python" },
  { import = "plugins.lsp.lang.zig" },
}
