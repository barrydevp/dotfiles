local navic = require("nvim-navic")

local kinds = {
  Array = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = "󰉋 ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  -- Module = " ",
  Module = " ",
  Namespace = " ",
  Null = "󰟢 ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}
-- local icons = require("nvchad.icons.lspkind")

navic.setup {
  icons = kinds,
  highlight = true,
  -- lsp = {
  --   auto_attach = true,
  -- },
  click = true,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
}

local M = {}

M.winbar_filetype_exclude = {
  "help",
  "dbui",
  "packer",
  "fugitive",
  "NvimTree",
  "Trouble",
  "spectre_panel",
  "toggleterm",
  "terminal",
  "",
}

function get_navic()
  local navic_data = navic.get_location()

  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    print(vim.bo.filetype)
    print(true)
    return ""
  end

  return navic_data
end

_G.navic_location = function()
  return get_navic()
end

-- vim.opt_local.winbar = "%!{%v:lua.navic_location()%}"

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
