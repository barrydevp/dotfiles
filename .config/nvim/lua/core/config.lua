local M = {}

M.code = {
  ai = "copilot", -- tabnine/copilotvim/copilot
}

M.ui = {
  theme = "catppuccin", -- default theme
  transparency = false,
  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  -- lazyload it when there are 1+ buffers
  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },

  lsp = {
    -- show function signatures i.e args as you type
    signature = {
      disabled = false,
      silent = false, -- silences 'no signature help available' message from appearing
    },
  },
}

M.lazy_nvim = require("plugins.configs.lazynvim") -- config for lazy.nvim startup options

M.mappings = require("core.mappings")

return M
