local fn = vim.fn
local contains = vim.contains

local M = {}

local special_chars = { "%", "*", "[", "]", "^", "$", "(", ")", ".", "+", "-", "?", '"' }

M.is_special = function(ch)
  return contains(special_chars, ch)
end

M.completion_visible = function()
  local hascmp, cmp = pcall(require, "cmp")
  if hascmp then
    -- reduce timeout from cmp's hardcoded 1000ms:
    -- https://github.com/ray-x/lsp_signature.nvim/issues/288
    cmp.core.filter:sync(42)
    return cmp.core.view:visible() or fn.pumvisible() == 1
  end

  return fn.pumvisible() ~= 0
end

return M
