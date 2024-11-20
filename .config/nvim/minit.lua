local opt = vim.opt
local g = vim.g
local map = vim.keymap.set

---- COLOR
vim.cmd.colorscheme("slate")

---- OPTIONS
-------------------------------------- globals -----------------------------------------
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
-- opt.scrolloff = 5
opt.scrolloff = 8 -- scroll page when cursor is 8 lines from top/bottom
opt.sidescrolloff = 8 -- scroll page when cursor is 8 spaces from left/rig

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
-- opt.wrap = true -- display long lines as just one line
opt.wrap = false -- display long lines as just one line

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

---- INDENT

-- python
vim.cmd([[autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]])
-- golang
vim.cmd([[autocmd Filetype go setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]])
-- js, ts
vim.cmd([[autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
vim.cmd([[autocmd Filetype jsx setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
vim.cmd([[autocmd Filetype typescript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
vim.cmd([[autocmd Filetype tsx setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
-- lua
vim.cmd([[autocmd Filetype lua setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
-- c/c++
vim.cmd([[autocmd Filetype c setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
vim.cmd([[autocmd Filetype h setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
vim.cmd([[autocmd Filetype cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2]])
--java
vim.cmd([[autocmd Filetype java setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]])
-- asm
vim.cmd([[autocmd Filetype asm setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4]])

---- KEY MAPS

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down> http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/ empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
-- Use control-c instead of escape
-- map("n", { "<C-c>", "<Esc>", { desc = "Esc" } })

-- Turn of search highlight
map("n", "<ESC>", "<cmd> noh <CR>", { desc = "no highlight" })

-- toogle previous file
map("n", "<S-Tab>", "<C-^>", { desc = "toggle previous file" })

-- switch between windows, this has been overridden by vim-tmux
map("n", "<C-h>", "<C-w>h", { desc = "window left" })
map("n", "<C-l>", "<C-w>l", { desc = "window right" })
map("n", "<C-j>", "<C-w>j", { desc = "window down" })
map("n", "<C-k>", "<C-w>k", { desc = "window up" })
-- resize windows
map("n", "<leader>H", ":vertical resize -2<CR>", { desc = "v-resize left" })
map("n", "<leader>L>", ":vertical resize +2<CR>", { desc = "v-resize right" })
map("n", "<leader>J", ":resize -2<CR>", { desc = "h-resize down" })
map("n", "<leader>K", ":resize +2<CR>", { desc = "h-resize up" })
-- better split
map("n", "<leader>-", ":vsplit<CR>", { desc = "v-split" })
map("n", "<leader>_", ":split<CR>", { desc = "h-split" })
map("n", '<leader>"', ":vsplit<CR>", { desc = "v-split" })
map("n", "<leader>%", ":split<CR>", { desc = "h-split" })
map("n", '<C-w>"', ":vsplit<CR>", { desc = "v-split" })
map("n", "<C-w>%", ":split<CR>", { desc = "h-split" })

-- save
-- map("n", { "<C-s>", "<cmd> w <CR>", { desc = "save file" } })

-- Copy all
-- map("n", {"<C-c>", "<cmd> %y+ <CR>", {desc="copy whole file"} })

-- jumping
map("n", "[g", "<C-o>", { desc = "go backward" })
map("n", "]g", "<C-i>", { desc = "go forward" })
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*zzzv")

-- quicklist movement -- already set in editor/trouble.lua
map("n", "[q", ":cprev<CR>", { desc = "quick list prev" })
map("n", "]q", ":cnext<CR>", { desc = "quick list next" })

-- loclist movement
map("n", "[l", ":lprev<CR>", { desc = "loclist list prev" })
map("n", "]l", ":lnext<CR>", { desc = "loclist list next" })

-- line numbers
map("n", "<leader>n", "<cmd> set nu! <CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd> set rnu! <CR>", { desc = "toggle relative number" })

-- go to  beginning and end
map({ "i", "c" }, "<C-a>", "<ESC>^i", { desc = "beginning of line" })
map({ "i", "c" }, "<C-e>", "<End>", { desc = "end of line" })

-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP', { desc = "paste" })

-- Block movement
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '>-2<CR>gv=gv")

-- better indenting
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })
-- greatest remap ever
map("x", "<leader>p", [["_dP]])

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
map("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

map("t", "<ESC><ESC>", termcodes("<C-\\><C-N>"), { desc = "escape terminal mode" })
map("t", "<C-w>", termcodes("<C-\\><C-N><C-w>"), { desc = "window command mode" })
map("t", "<C-h>", termcodes("<C-\\><C-N><C-w>h"), { desc = "terminal window left" })
map("t", "<C-l>", termcodes("<C-\\><C-N><C-w>l"), { desc = "terminal window right" })
map("t", "<C-j>", termcodes("<C-\\><C-N><C-w>j"), { desc = "terminal window down" })
map("t", "<C-k>", termcodes("<C-\\><C-N><C-w>k"), { desc = "terminal window up" })

-- navigate within insert mode
map({ "i", "c" }, "<C-b>", "<Left>", { desc = "move left" })
map({ "i", "c" }, "<C-f>", "<Right>", { desc = "move right" })
-- map({"i", "c"}, "<C-h>", "<Left>", { desc = "move left" })
-- map({"i", "c"}, "<C-l>", "<Right>", { desc = "move right" })
-- map({"i", "c"}, "<C-j>", "<Down>", { desc = "move down" })
-- map({"i", "c"}, "<C-k>", "<Up>", { desc = "move up" })
map({ "i", "c" }, "<C-k>", "<C-O>D", { desc = "delete line to end" })
map({ "i", "c" }, "<C-d>", "<Del>", { desc = "<Del>" })
map({ "i", "c" }, "<C-h>", "<BS>", { desc = "<BS>" })

-- don't yank text on cut ( x )
-- map({"n", "v"}, x", '"_x', {desc="cut"})
-- don't yank text on delete ( dd )
-- map({"n", "v"}, d", '"_d', {desc="delete"})

-- plugins
map("n", "<leader>e", "<cmd> Explore <CR>", { desc = "toggle NETRW" })

