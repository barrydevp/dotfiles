local core = require("plugins.lsp.core")

-- load UI
require("core.ui.lsp")

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = core.servers

for _, lang in ipairs(servers) do
  local ok, _ = pcall(require, "plugins.lsp.lang." .. lang)
  if not ok then
    core.setup_default(lang)
  end
end
