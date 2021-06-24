local cmd = vim.cmd
local g = vim.g
local api = vim.api

-- Set leader
api.nvim_set_keymap('n', ',', '<NOP>', {noremap = true, silent = true})
g.mapleader = ','
g.auto_save = 0

-- colorscheme related stuff
cmd "syntax on"

local base16 = require "base16"
base16(base16.themes["onedark"], true)

-- blankline, indent

local indent = 2

g.indentLine_enabled = 1
g.indent_blankline_char = "▏"

g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = false

cmd('set expandtab') -- Converts tabs to spaces

-- hide line numbers in terminal windows
api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)

-- loading some options

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

opt("o", "hidden", true)
opt("o", "ignorecase", true)
opt("o", "splitbelow", true)
opt("o", "splitright", true)
opt("o", "termguicolors", true)
opt("w", "number", true)
opt("w", "relativenumber", true)
opt("o", "numberwidth", 2)
opt("o", "scrolloff", 5)
opt("w", "cul", true)

opt("o", "mouse", "a")

opt("w", "signcolumn", "yes")
opt("o", "cmdheight", 1)

opt("o", "updatetime", 250) -- update interval for gitsigns
opt("o", "clipboard", "unnamedplus")
opt("o", "timeoutlen", 500)

-- for indenline
opt("b", "expandtab", true)
opt("b", "shiftwidth", 2)
opt("b", "tabstop", 2)
opt("b", "softtabstop", 2)
opt("b", "smartindent", true)
require('settings.indent')

local M = {}

function M.is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function M.has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end

return M
