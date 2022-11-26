local core = require("plugins.lsp.core")

-- go
require("lspconfig").gopls.setup({
  on_attach = core.on_attach,
  capabilities = core.capabilities,

  cmd = { "gopls", "serve" },
  settings = {
    gopls = {
      analyses = {
        composites = false,
      },
    },
  },
})

