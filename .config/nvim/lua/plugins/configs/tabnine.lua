return {
  disable_auto_comment = false, -- already have an autocmd for this
  accept_keymap = "<A-]>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  suggestion_color = { gui = "#808080", cterm = 244 },
  exclude_filetypes = { "TelescopePrompt", "NvimTree", "terminal" },
  log_file_path = nil, -- absolute path to Tabnine log file
  codelens_enabled = false,
}
