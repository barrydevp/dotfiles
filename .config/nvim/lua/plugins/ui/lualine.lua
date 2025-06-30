return {
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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

      local function isEmpty()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end

      lualine.setup {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          -- component_separators = { left = icons.ui.SeperatorLeft, right = icons.ui.SeperatorRight },
          -- section_separators = { left = icons.ui.SeperatorLeftFill, right = icons.ui.SeperatorRightFill },
          section_separators = "",
          component_separators = "",
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
            { "filename", path = 0 },
            -- { "filesize", cond = isEmpty },
            { "location" },
            { "progress" },
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
          -- lualine_z = {
          --   function()
          --     return " " .. os.date("%R")
          --   end,
          -- },
        },
        extensions = {
          "fugitive",
          "nvim-tree",
          "symbols-outline",
          "quickfix",
          "fzf",
          gitcommit,
        },
      }
    end,
  },
}
