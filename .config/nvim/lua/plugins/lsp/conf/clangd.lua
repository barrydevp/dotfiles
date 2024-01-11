local core = require("plugins.lsp.core")

require("lspconfig").clangd.setup {
  on_attach = core.on_attach,
  capabilities = core.capabilities,
}
