local map = vim.keymap.set
local vscode = require("vscode")

-- window
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

-- stylua: ignore start
-- explorer
map("n", "<leader>e", function() vscode.action("workbench.view.explorer") end, { desc = "toggle nvimtree" })

-- telescope
-- map("n", "<C-p>", function() vscode.action("workbench.action.quickOpen") end, { desc = "Find files" })
-- map("n", "<C-/>", function() vscode.action("workbench.action.findInFiles") end, { desc = "Search in files" })

-- terminal
-- map("n", "<C-\\>", function() vscode.action("workbench.action.terminal.focus") end, { desc = "Focus terminal" })

-- editor
map("n", "<leader>x", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close tab" })
-- map("n", "<C-t>x", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close tab" })
-- map("n", "<C-t>W", function() vscode.action("workbench.action.closeOtherEditors") end, { desc = "Close other tabs" })
