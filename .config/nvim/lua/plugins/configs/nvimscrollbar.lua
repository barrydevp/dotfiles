local present, scrollbar = pcall(require, "scrollbar")

if not present then
  return
end

scrollbar.setup {
  handle = {
    text = "  ",
    highlight = "ScrollBarHandle",
  },
  marks = {
    Cursor = {
      text = "••",
      priority = 0,
      color = nil,
      cterm = nil,
      highlight = "ScrollBarCursor",
    },
    Search = {
      text = { "--", "==" },
    },
    Error = {
      text = { "--", "==" },
    },
    Warn = {
      text = { "--", "==" },
    },
    Info = {
      text = { "--", "==" },
    },
    Hint = {
      text = { "--", "==" },
    },
    Misc = {
      text = { "--", "==" },
    },
    -- Search = { color = colors.orange },
    -- Error = { color = colors.error },
    -- Warn = { color = colors.warning },
    -- Info = { color = colors.info },
    -- Hint = { color = colors.hint },
    -- Misc = { color = colors.purple },
  },
  -- folds = false,
  -- marks = {
  --   Search = { color = colors.orange },
  --   GitAdd = { text = "│" },
  --   GitChange = { text = "│" },
  --   GitDelete = { text = "│" },
  -- },
  excluded_filetypes = {
    "help",
    "NvimTree",
    "terminal",
    "fugitive",
  },
}
