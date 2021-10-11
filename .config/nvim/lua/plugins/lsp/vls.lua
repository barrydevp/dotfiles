local lspconf = require("lspconfig")

-- vls conf example
local vls_binary = "/usr/local/bin/vls"
lspconf.vls.setup {
    cmd = {vls_binary}
}

