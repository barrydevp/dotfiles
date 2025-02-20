local M = {}

M.coding = {
  ai = "copilot", -- tabnine/copilotvim/copilot
}

M.ui = {
  theme = "catppuccin", -- default theme
  transparency = true,
  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens
}

M.icons = require("core.icons")

return M
