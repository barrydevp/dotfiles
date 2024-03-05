local lualine = require("lualine")

-- Extensions
local gitcommit = {
  sections = {
    lualine_a = {
      function()
        local icon = "" -- e0a0
        return icon .. " " .. vim.fn.FugitiveHead()
      end,
    },
    lualine_b = {
      function()
        return [[Commit]]
      end,
    },
  },
  filetypes = { "gitcommit" },
}

-- local function session_status()
--   local name = require("auto-session.lib").current_session_name()
--   if not isEmpty(name) then
--     --[[ return " " .. name ]]
--     return " "
--   end
--   return ""
-- end

local function cwd_name()
  local t = {}
  for str in string.gmatch(vim.fn.getcwd(), "([^" .. "/" .. "]+)") do
    table.insert(t, str)
  end
  return " " .. t[#t]
end

lualine.setup {
  theme = "catppuccin",
  options = {
    globalstatus = true,
    -- component_separators = { left = icons.ui.SeperatorLeft, right = icons.ui.SeperatorRight },
    -- section_separators = { left = icons.ui.SeperatorLeftFill, right = icons.ui.SeperatorRightFill },
    ignore_focus = {
      "NvimTree",
      "toggleterm",
      "Trouble",
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      { cwd_name },
      { "filename", path = 1 },
    },
    lualine_x = {
      -- {
      --   require("noice").api.status.search.get,
      --   cond = require("noice").api.status.search.has,
      --   color = { fg = "ff9e64" },
      -- },
      -- {
      --   require("noice").api.status.command.get,
      --   cond = require("noice").api.status.command.has,
      --   color = { fg = "ff9e64" },
      -- },
      -- { session_status },
      "encoding",
      "fileformat",
      "filetype",
    },
  },
  extensions = {
    "fugitive",
    "nvim-tree",
    "symbols-outline",
    "quickfix",
    gitcommit,
  },
}
