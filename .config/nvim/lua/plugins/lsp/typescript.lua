local core = require("plugins.lsp.core")

-- tsserver
require("typescript").setup {
  server = {
    on_attach = core.on_attach,
    capabilities = core.capabilities,
  },
}
