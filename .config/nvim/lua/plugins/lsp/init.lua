local lspconfig = require("lspconfig")

local core = require("plugins.lsp.core")

-- load UI
core.ui()

-- attach handlers
-- core.handlers()

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = {
  "lua_ls",
  "vls",
  -- "ccls",
  "clangd",
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
  local ok, _ = pcall(require, "plugins.lsp." .. lang)
  if not ok then
    core.setup_default(lang)
  end
end

-- null-ls
core.nullls()
