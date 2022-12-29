local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local core = require("plugins.lsp.core")

-- load UI
core.ui()

-- attach handlers
core.handlers()

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = {
  "sumneko_lua",
  "vls",
  "ccls",
  "html",
  "cssls",
  "tsserver",
  "pyright",
  "bashls",
  "gopls",
  "jdtls",
  "rust_analyzer",
}

for _, lang in ipairs(servers) do
  local ok, err = pcall(require, "plugins.lsp." .. lang)
  if not ok then
    core.setup_default(lang)
  end
end

-- null-ls
core.nullls()
