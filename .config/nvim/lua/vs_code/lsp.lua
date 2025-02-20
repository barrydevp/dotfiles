local map = vim.keymap.set
local vscode = require("vscode")
local LspFn = require("utils.lsp")

LspFn.format = vim.lsp.buf.format
LspFn.renamer = vim.lsp.buf.rename
LspFn.parameter_hints = vim.lsp.buf.signature_help
LspFn.open_line_diagnostics = vim.lsp.buf.hover

map("n", "<leader>lf", LspFn.format, { desc = "Lsp format" })

local keys = require("core.lsp").keys
require("utils").set_keymaps(keys)
