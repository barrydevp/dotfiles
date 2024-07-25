local M = {}

M.coding = {
  ai = "copilotvim", -- tabnine/copilotvim/copilot
}

M.ui = {
  theme = "catppuccin", -- default theme
  transparency = true,
  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  -- lazyload it when there are 1+ buffers
  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = false,
    overriden_modules = nil,
  },
}

M.keymaps = require("core.keymaps")

return M
