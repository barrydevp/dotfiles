local merge_tb = vim.tbl_deep_extend
local M = {}

local modes_map = {
  ["_"] = { "" },
  ["n"] = { "n" },
  ["v"] = { "v" },
  ["s"] = { "s" },
  ["x"] = { "x" },
  ["o"] = { "o" },
  ["!"] = { "!" },
  ["i"] = { "i" },
  ["l"] = { "l" },
  ["c"] = { "c" },
  ["t"] = { "t" },

  -- multiple
  ["nv"] = { "n", "v" },
}

M.load_mappings = function(section, mapping_opt, sources)
  vim.schedule(function()
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end
      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          -- merge default + user opts
          local opts = merge_tb("force", default_opts, mapping_info.opts or {})

          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]

          for _, m in ipairs(modes_map[mode]) do
            vim.keymap.set(m, keybind, mapping_info[1], opts)
          end
        end
      end
    end

    local mappings = sources or require("mappings")

    if type(section) == "string" then
      mappings[section]["plugin"] = nil
      mappings = { mappings[section] }
    end

    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

return M
