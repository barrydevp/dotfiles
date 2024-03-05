-- local colors = require("catppuccin.palettes").get_palette()

return {
  disable_auto_comment = true,
  accept_keymap = "<A-]>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  -- suggestion_color = { gui = colors.overlay2 },
  suggestion_color = { gui = "#808080", cterm = 244 },
  exclude_filetypes = { "TelescopePrompt", "NvimTree", "terminal" },
  log_file_path = nil, -- absolute path to Tabnine log file
  codelens_enabled = false,
}
