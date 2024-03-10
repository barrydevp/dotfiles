local core = require("plugins.lsp.core")
local lspconf = require("lspconfig")

-- vls conf example
local vls_binary = "/usr/local/bin/vls"
lspconf.vls.setup {
  on_init = core.on_init,
  on_attach = core.on_attach,
  cmd = { vls_binary },
}
