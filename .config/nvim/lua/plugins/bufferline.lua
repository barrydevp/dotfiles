-- require "bufferline".setup {
--     options = {
--         offsets = {{filetype = "NvimTree", text = "Explorer", padding = 2}},
--         buffer_close_icon = "",
--         modified_icon = "",
--         close_icon = "",
--         left_trunc_marker = "",
--         right_trunc_marker = "",
--         max_name_length = 14,
--         max_prefix_length = 13,
--         tab_size = 20,
--         show_tab_indicators = true,
--         enforce_regular_tabs = false,
--         view = "multiwindow",
--         show_buffer_close_icons = true,
--         separator_style = "thin"
--     }
-- }
-- 
-- local opt = {silent = true}
-- local map = vim.api.nvim_set_keymap
-- 
-- -- MAPPINGS
-- map("n", "<S-t>", [[<Cmd>tabnew<CR>]], opt) -- new tab
-- -- map("n", "<S-x>", [[<Cmd>bdelete<CR>]], opt) -- close tab
-- map("n", "<leader>c", "[[<Cmd>BufferLinePick<CR>]]", opt)
-- 
-- -- move between tabs
-- map("n", "<TAB>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
-- map("n", "<S-TAB>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)
-- map("n", "<leader>p", "[[<Cmd>BufferLinePick<CR>]]", opt)
-- 
-- -- BufferLineGotoBuffer
-- map("n", "<leader>1", "[[<Cmd>BufferLineGoToBuffer 1<CR>]]", opt)
-- map("n", "<leader>2", "[[<Cmd>BufferLineGoToBuffer 2<CR>]]", opt)
-- map("n", "<leader>3", "[[<Cmd>BufferLineGoToBuffer 3<CR>]]", opt)
-- map("n", "<leader>4", "[[<Cmd>BufferLineGoToBuffer 4<CR>]]", opt)
-- map("n", "<leader>5", "[[<Cmd>BufferLineGoToBuffer 5<CR>]]", opt)
-- map("n", "<leader>6", "[[<Cmd>BufferLineGoToBuffer 6<CR>]]", opt)
-- map("n", "<leader>7", "[[<Cmd>BufferLineGoToBuffer 7<CR>]]", opt)
-- map("n", "<leader>8", "[[<Cmd>BufferLineGoToBuffer 8<CR>]]", opt)
-- map("n", "<leader>9", "[[<Cmd>BufferLineGoToBuffer 9<CR>]]", opt)

local utils = require("utils")
local colors = utils.get_colors("onedark")

local present, bufferline = pcall(require, "bufferline")
if not present then
   return
end

bufferline.setup {
   options = {
      offsets = { { filetype = "NvimTree", text = "Explorer", padding = 1 } },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = true,
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false, -- "or nvim_lsp"
      custom_filter = function(buf_number)
         -- Func to filter out our managed/persistent split terms
         local present_type, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf_number, "term_type")
         end)

         if present_type then
            if type == "vert" then
               return false
            elseif type == "hori" then
               return false
            else
               return true
            end
         else
            return true
         end
      end,
   },

   highlights = {
      background = {
         guifg = colors.grey_fg,
         guibg = colors.black2,
      },

      -- buffers
      buffer_selected = {
         guifg = colors.white,
         guibg = colors.black,
         gui = "bold",
      },
      buffer_visible = {
         guifg = colors.light_grey,
         guibg = colors.black2,
      },

      -- for diagnostics = "nvim_lsp"
      error = {
         guifg = colors.light_grey,
         guibg = colors.black2,
      },
      error_diagnostic = {
         guifg = colors.light_grey,
         guibg = colors.black2,
      },

      -- close buttons
      close_button = {
         guifg = colors.light_grey,
         guibg = colors.black2,
      },
      close_button_visible = {
         guifg = colors.light_grey,
         guibg = colors.black2,
      },
      close_button_selected = {
         guifg = colors.red,
         guibg = colors.black,
      },
      fill = {
         guifg = colors.grey_fg,
         guibg = colors.black2,
      },
      indicator_selected = {
         guifg = colors.black,
         guibg = colors.black,
      },

      -- modified
      modified = {
         guifg = colors.red,
         guibg = colors.black2,
      },
      modified_visible = {
         guifg = colors.red,
         guibg = colors.black2,
      },
      modified_selected = {
         guifg = colors.green,
         guibg = colors.black,
      },

      -- separators
      separator = {
         guifg = colors.black2,
         guibg = colors.black2,
      },
      separator_visible = {
         guifg = colors.black2,
         guibg = colors.black2,
      },
      separator_selected = {
         guifg = colors.black2,
         guibg = colors.black2,
      },
      -- tabs
      tab = {
         guifg = colors.light_grey,
         guibg = colors.one_bg3,
      },
      tab_selected = {
         guifg = colors.black2,
         guibg = colors.nord_blue,
      },
      tab_close = {
         guifg = colors.red,
         guibg = colors.black,
      },
   },
}

