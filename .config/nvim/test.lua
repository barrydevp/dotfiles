-- print(vim.inspect(vim.iter({ -- remove nil
--   1 > 1 and '' or nil,
--   '---@class ' .. "hello rufk",
-- }):flatten():totable()))
--
print(vim.inspect(require("nvim-treesitter.compat").flatten {{}, 1, 2, 3}))

for _, m in ipairs { "select", "move", "repeatable_move", "swap", "lsp_interop" } do
  print(vim.inspect(require("nvim-treesitter.textobjects." .. m).commands))
end
