local M = {}

M.format = function(bufnr)
  require("conform").format {
    lsp_fallback = true,
    async = true,
    timeout_ms = 500,
  }
end

M.renamer = function()
  require("plugins.lsp.ui.renamer").open()
end

M.signature = function()
  vim.lsp.buf.signature_help()
end

M.parameter_hints = function()
  vim.lsp.buf.signature_help()
  require("plugins.lsp.ui.signature").parameter_hints()
end

M.diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
