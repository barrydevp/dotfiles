local config = require("core.config")

local M = {
  default = {},
  tabnine = {},
  copilotvim = {},
  copilot = {},
}

M.default.accept = function()
  return false
end

M.tabnine.accept = function()
  local completion = require("tabnine.completion")
  local state = require("tabnine.state")

  if state.completions_cache then
    vim.schedule(completion.accept)
    return true
  end

  return false
end

M.copilotvim.accept = function()
  local cmd = vim.fn["copilot#Accept"]("\\<CR>")
  if cmd ~= "\\<CR>" then
    vim.api.nvim_feedkeys(cmd, "n", true)

    return true
  end

  return false
end

M.copilot.accept = function()
  return require("copilot.suggestion").accept()
end

-- set AI code generation completion
M.accept = (function()
  return (M[config.code.ai] or M.default)["accept"]
end)()

return M
