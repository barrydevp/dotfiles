local core = require("plugins.lsp.core")

require("lspconfig").rust_analyzer.setup {
  on_attach = core.on_attach,
  capabilities = core.capabilities,

  cmd = { "rust-analyzer" },
  settings = {
    {
      ["rust-analyzer"] = {
        -- ["rust-analyzer.cargo.target"] = "",
        ["rust-analyzer.checkOnSave.allTargets"] = false,
      },
    },
  },
}
