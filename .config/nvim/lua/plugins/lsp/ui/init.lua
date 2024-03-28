local function lspSymbol(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol("Error", "󰅙")
lspSymbol("Info", "󰋼")
lspSymbol("Hint", "󰌵")
lspSymbol("Warn", "")

vim.diagnostic.config {
  virtual_text = {
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- border = "single",
  relative = "cursor",
  -- max_height = 12, -- max height of signature floating_window
  -- max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  wrap = true,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  -- border = "single",
  focusable = false,
  relative = "cursor",
  -- silent = true,
  -- max_height = 12, -- max height of signature floating_window
  -- max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  wrap = true,
})

return {}
