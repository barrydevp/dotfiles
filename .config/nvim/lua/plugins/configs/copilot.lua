vim.g.copilot_no_tab_map = true

local M = {}

M.accept = function()
  local cmd = vim.fn["copilot#Accept"]("\\<CR>")
  if cmd ~= "\\<CR>" then
    vim.api.nvim_feedkeys(cmd, "n", true)

    return true
  end

  return false
end

return M
