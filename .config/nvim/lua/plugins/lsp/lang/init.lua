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
        prettierd = {},
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
        json = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        handlebars = { "prettierd", "prettier" },
        less = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" },
        ["markdown.mdx"] = { "prettierd", "prettier" },
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
  { import = "plugins.lsp.lang.tsserver" },
  { import = "plugins.lsp.lang.java" },
  { import = "plugins.lsp.lang.python" },
  { import = "plugins.lsp.lang.zig" },
}
