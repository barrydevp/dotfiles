return {

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        vls = {},
        html = {},
        cssls = {},
        pyright = {},
        bashls = {},

        stylua = {},
        prettierd = {},
        isort = {},
        shfmt = {},
        goimports = {},
        gofumpt = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
        htmldjango = { "djhtml" },
        bib = { "bibclean" },
        tex = { "latexindent" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        handlebars = { { "prettierd", "prettier" } },
        less = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        sh = { "shfmt" },
        go = { "goimports", "gofumpt" },
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
        pyright = {},
        bashls = {},
      },
    },
  },

  -- other language servers
  { import = "plugins.lsp.lang.lua_ls" },
  { import = "plugins.lsp.lang.clangd" },
}
