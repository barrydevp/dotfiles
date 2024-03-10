local M = {}

M.load_config = function()
  local config = require("core.config")
  return config
end

M.load_mappings = function(section, opts)
  local mappings = require("core.utils").load_config().mappings
  local sects = mappings[section or "default"]

  for mode, sect in pairs(sects) do
    for _, args in ipairs(sect) do
      -- [1] lhs, [2] rhs, [3] opts
      vim.keymap.set(mode, args[1], args[2], vim.tbl_extend("force", opts or {}, args[3] or {}))
    end
  end
end

return M
