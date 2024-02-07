require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
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

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
