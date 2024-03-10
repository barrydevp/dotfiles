local gitsigns = require("gitsigns")

gitsigns.setup {
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  on_attach = function(bufnr)
    require("core.utils").load_mappings("git", { buffer = bufnr })
  end,
}
