local lazyutils = require("utils.lazy")

local M = {}

---@return {default_config:lspconfig.Config}
function M.get_raw_config(server)
  local ok, ret = pcall(require, "lspconfig.configs." .. server)
  if ok then
    return ret
  end
  return require("lspconfig.server_configurations." .. server)
end

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open {
      mode = "lsp_command",
      params = params,
    }
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      }
    end
  end,
})

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client:supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

---@param opts? lsp.Client.format
function M.format(opts)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    lazyutils.opts("nvim-lspconfig").format or {},
    lazyutils.opts("conform.nvim").format or {}
  )
  -- print(vim.inspect(opts))
  local ok, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

M.renamer = function()
  -- require("plugins.lsp.ui.renamer").open()
  local inc_rename = require("inc_rename")
  return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
end

M.open_line_diagnostics = function()
  vim.diagnostic.open_float()
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

M.jump_reference = function(next)
  local step = next and vim.v.count1 or -vim.v.count1
  Snacks.words.jump(step, true)
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
