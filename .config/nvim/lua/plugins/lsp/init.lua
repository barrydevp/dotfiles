local core = require("plugins.lsp.core")

-- load UI
require("nvchad.lsp")

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = core.servers

for _, lang in ipairs(servers) do
  local ok, _ = pcall(require, "plugins.lsp.conf." .. lang)
  if not ok then
    core.setup_default(lang)
  end
end

-- null-ls
core.nullls()
