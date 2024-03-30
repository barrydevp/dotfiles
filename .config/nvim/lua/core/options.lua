local opt = vim.opt
local g = vim.g
local config = require("core.config")

-------------------------------------- globals -----------------------------------------
g.transparency = config.ui.transparency

-- general
opt.iskeyword:append("-") -- treat dash separated words as a word text object"
g.mapleader = " "

opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.winblend = 16

-- opt.title = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
-- opt.hidden = true

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.relativenumber = true
opt.scrolloff = 5

-- disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.colorcolumn = "80"
opt.timeoutlen = 300
opt.undofile = true
opt.smoothscroll = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
opt.wrap = true -- display long lines as just one line

-- fold
-- opt.foldlevel = 20
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- indentblankline
opt.list = true
opt.listchars:append("leadmultispace:⋅")
opt.listchars:append("eol:↴")

-- obsidian
opt.conceallevel = 2
