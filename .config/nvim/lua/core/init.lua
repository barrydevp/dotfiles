_G.Core = {
  snippet_stop = function() end,
}

require("core.options")
require("core.cmds")
if not vim.g.vscode then
  require("core.auto_commands")
end
-- require("core.indents")

-- set general mapping
require("core.keymaps")
