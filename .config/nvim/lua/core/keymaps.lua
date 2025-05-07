local map = vim.keymap.set

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
-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  Core.snippet_stop()
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- toogle previous file
-- map("n", "<S-Tab>", "<C-^>", { desc = "toggle previous file" })

-- switch between windows, this has been overridden by vim-tmux
map("n", "<C-h>", "<C-w>h", { desc = "window left" })
map("n", "<C-l>", "<C-w>l", { desc = "window right" })
map("n", "<C-j>", "<C-w>j", { desc = "window down" })
map("n", "<C-k>", "<C-w>k", { desc = "window up" })

-- resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
-- map("n", "<leader>H", ":vertical resize -2<CR>", { desc = "v-resize left" })
-- map("n", "<leader>L", ":vertical resize +2<CR>", { desc = "v-resize right" })
-- map("n", "<leader>J", ":resize -2<CR>", { desc = "h-resize down" })
-- map("n", "<leader>K", ":resize +2<CR>", { desc = "h-resize up" })

-- better split
map("n", "<leader>-", ":vsplit<CR>", { desc = "v-split" })
map("n", "<leader>_", ":split<CR>", { desc = "h-split" })
map("n", '<leader>"', ":vsplit<CR>", { desc = "v-split" })
map("n", "<leader>%", ":split<CR>", { desc = "h-split" })
map("n", '<C-w>"', ":vsplit<CR>", { desc = "v-split" })
map("n", "<C-w>%", ":split<CR>", { desc = "h-split" })

-- buffers
-- map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- save
-- map("n", { "<C-s>", "<cmd> w <CR>", { desc = "save file" } })

-- Copy all
-- map("n", {"<C-c>", "<cmd> %y+ <CR>", {desc="copy whole file"} })

-- jumping
map("n", "[g", "<C-o>", { desc = "go backward" })
map("n", "]g", "<C-i>", { desc = "go forward" })
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
-- map("n", "n", "nzzzv")
-- map("n", "N", "Nzzzv")
map("n", "*", "*zzzv")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

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
-- map({ "i", "c" }, "<C-a>", "<ESC>^i", { desc = "beginning of line" })
map({ "i", "c" }, "<C-a>", "<Home>", { desc = "beginning of line" })
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

-- terminal
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
