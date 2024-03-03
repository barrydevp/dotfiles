local null_ls = require("null-ls")
local lsp_core = require("plugins.lsp.core")

local builtins = null_ls.builtins

local sources = {
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
  builtins.code_actions.gomodifytags,
  builtins.code_actions.impl,
}

null_ls.setup {
  sources = sources,
  -- on_attach = lsp_core.on_attach,
  debounce = 150,
}
