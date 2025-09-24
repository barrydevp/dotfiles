local map = vim.keymap.set
-- local vscode = require("vscode")
local Utils = require("utils")

Utils.lsp.format = vim.lsp.buf.format
Utils.lsp.renamer = vim.lsp.buf.rename
Utils.lsp.parameter_hints = vim.lsp.buf.signature_help
Utils.lsp.open_line_diagnostics = vim.lsp.buf.hover

map("n", "<leader>lf", Utils.lsp.format, { desc = "Lsp format" })

local keys = require("core.lsp").keys
Utils.set_keymaps(keys)
