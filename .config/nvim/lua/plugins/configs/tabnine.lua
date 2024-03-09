-- local colors = require("catppuccin.palettes").get_palette()
local completion = require("tabnine.completion")
local state = require("tabnine.state")

return {
  disable_auto_comment = false, -- already have an autocmd for this
  accept_keymap = "<A-]>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  -- suggestion_color = { gui = colors.overlay2 },
  suggestion_color = { gui = "#808080", cterm = 244 },
  exclude_filetypes = { "TelescopePrompt", "NvimTree", "terminal" },
  log_file_path = nil, -- absolute path to Tabnine log file
  codelens_enabled = false,

  accept = function()
    if state.completions_cache and state.rendered_completion then
      vim.schedule(completion.accept)
      return true
    end

    return false
  end,
}
