local M = {}

---@param on_attach fun(client:vim.lsp.Client, buffer)
function M.on_attach(on_attach)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        return on_attach(client, buffer)
      end
    end,
  })
end

M.format = function(bufnr)
  require("conform").format {}
end

M.renamer = function()
  require("plugins.lsp.ui.renamer").open()
end

M.signature = function()
  vim.lsp.buf.signature_help {
    -- border = "single",
    focusable = false,
    relative = "cursor",
    -- silent = true,
    -- max_height = 12, -- max height of signature floating_window
    -- max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    wrap = true,
  }
end

M.hover = function()
  vim.lsp.buf.hover {
    -- border = "single",
    relative = "cursor",
    -- max_height = 12, -- max height of signature floating_window
    -- max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    wrap = true,
  }
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
