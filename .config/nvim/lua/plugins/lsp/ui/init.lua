local icons = require("core.icons")

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = function(diagnostic)
      for d, icon in pairs(icons.diagnostics) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon
        end
      end
      return " "
    end,
  },
  signs = false,
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
