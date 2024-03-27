local config = require("core.config")
local M = {}

M.set_keymaps = function(mappings, opts)
  for mode, mapping in pairs(mappings) do
    for _, args in ipairs(mapping) do
      -- [1] lhs, [2] rhs, [3] opts
      vim.keymap.set(mode, args[1], args[2], vim.tbl_extend("force", opts or {}, args[3] or {}))
    end
  end
end

M.load_mappings = function(section, opts)
  local mappings = config.mappings
  local sects = mappings[section or "default"]

  M.set_keymaps(sects, opts)
end

M.plugin_opts = function(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
