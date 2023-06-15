local gitsigns = require("gitsigns")

-- for Git UI
-- UI
require("core.view").register("Git UI", {
  map = "<leader>gu",
  open = ":topleft vert Git",
  close = ":bd!",
  width = 40,
})

gitsigns.setup {
  signs = {
    add = { hl = "DiffAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    changedelete = { hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
  },
  on_attach = function(bufnr)
    require("core.utils").load_mappings("gitsigns", { buffer = bufnr })
  end,
}
