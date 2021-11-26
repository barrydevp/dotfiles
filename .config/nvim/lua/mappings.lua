local utils = require "utils"

local cmd = vim.cmd
local map = utils.map

local opt = {noremap = true}

local maps = {
   -- custom = {}, -- all custom user mappings
   -- close current focused buffer
   close_buffer = "<leader>c",
   copy_whole_file = "<C-a>", -- copy all contents of the current buffer
   line_number_toggle = "<leader>n", -- show or hide line number
   new_buffer = "<C-n>b", -- open a new buffer
   new_tab = "<C-n>t", -- open a new vim tab
   save_file = "<C-s>", -- save file using :w
   theme_toggler = "<leader>tt", -- for theme toggler, see in ui.theme_toggler
   -- navigation in insert mode, only if enabled in options
   insert_nav = {
      backward = "<C-h>",
      end_of_line = "<C-e>",
      forward = "<C-l>",
      next_line = "<C-k>",
      prev_line = "<C-j>",
      top_of_line = "<C-a>",
   },
   --better window movement
   window_nav = {
      moveLeft = "<C-h>",
      moveRight = "<C-l>",
      moveUp = "<C-k>",
      moveDown = "<C-j>",
   },
   -- terminal related mappings
   terminal = {
      -- multiple mappings can be given for esc_termmode and esc_hide_termmode
      -- get out of terminal mode
      esc_termmode = { "jk" }, -- multiple mappings allowed
      -- get out of terminal mode and hide it
      esc_hide_termmode = { "JK" }, -- multiple mappings allowed
      -- show & recover hidden terminal buffers in a telescope picker
      pick_term = "<leader>W",
      -- below three are for spawning terminals
      new_horizontal = "<leader>t",
      new_vertical = "<leader>y",
      new_window = "<leader>w",
   },
   window_split = {
       vertical = "<leader>-",
       horizontal = "<leader>_",
   },
}
-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP')

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- use ESC to turn off search highlighting
map("n", "<Esc>", ":noh <CR>")

-- don't yank text on cut ( x )
-- map({ "n", "v" }, "x", '"_x')

-- don't yank text on delete ( dd )
-- map({ "n", "v" }, "d", '"_d')

map("n", maps.close_buffer, ":lua require('utils').close_buffer() <CR>") -- close  buffer
map("n", maps.copy_whole_file, ":%y+ <CR>") -- copy whole file content
map("n", maps.new_buffer, ":enew <CR>") -- new buffer
map("n", maps.new_tab, ":tabnew <CR>") -- new tabs
map("n", maps.line_number_toggle, ":set nu! <CR>") -- toggle numbers
map("n", maps.save_file, ":w <CR>") -- ctrl + s to save file

-- terminal mappings --
local term_maps = maps.terminal
-- get out of terminal mode
map("t", term_maps.esc_termmode, "<C-\\><C-n>")
-- hide a term from within terminal mode
map("t", term_maps.esc_hide_termmode, "<C-\\><C-n> :lua require('utils').close_buffer() <CR>")
-- pick a hidden term
map("n", term_maps.pick_term, ":Telescope terms <CR>")
-- Open terminals
-- TODO this opens on top of an existing vert/hori term, fixme
map("n", term_maps.new_horizontal, ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
map("n", term_maps.new_vertical, ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")
map("n", term_maps.new_window, ":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>")
-- terminal mappings end --

-- Add Packer commands because we are not loading it at startup
-- cmd "silent! command PackerClean lua require 'plugins' require('packer').clean()"
-- cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
-- cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
-- cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
-- cmd "silent! command PackerSync lua require 'plugins' require('packer').sync()"
-- cmd "silent! command PackerUpdate lua require 'plugins' require('packer').update()"

-- add NvChadUpdate command and mapping
-- cmd "silent! command! NvChadUpdate lua require('nvchad').update_nvchad()"
-- map("n", maps.update_nvchad, ":NvChadUpdate <CR>")

-- add ChadReload command and maping
-- cmd "silent! command! NvChadReload lua require('nvchad').reload_config()"

-- OPEN TERMINALS --
map("n", "<M-l>", [[<Cmd>vnew term://zsh <CR>]], opt) -- over right
map("n", "<M-j>", [[<Cmd> split term://zsh | resize 10 <CR>]], opt) --  bottom
map("n", "<C-n>t", [[<Cmd> tabnew | term <CR>]], opt) -- newtab
-- exit from terminal buffer
-- map("t", "<C-[><C-[>", "<C-\\><C-n>", {silent = true, noremap = true})

-- COPY EVERYTHING in the file--
map("n", "<C-a>", [[ <Cmd> %y+<CR>]], opt)

-- toggle numbers ---
map("n", "<leader>n", [[ <Cmd> set nu!<CR>]], opt)

map("n", "<C-s>", [[ <Cmd> w <CR>]], opt) -- save

-- better window movement
local wnav = maps.window_nav

map("n", wnav.moveLeft, "<C-w>h")
map("n", wnav.moveRight, "<C-w>l")
map("n", wnav.moveUp, "<C-w>k")
map("n", wnav.moveDown, "<C-w>j")

-- better split
local wsplit = maps.window_split
-- map('n', '<leader>h', ':ls<cr> :vertical sb ', {})
map('n', wsplit.vertical, ':vsplit<CR>', {})
map('n', wsplit.horizontal, ':split<CR>', {})

-- TODO fix this
-- Terminal window navigation
vim.cmd([[
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
  inoremap <C-h> <C-\><C-N><C-w>h
  inoremap <C-j> <C-\><C-N><C-w>j
  inoremap <C-k> <C-\><C-N><C-w>k
  inoremap <C-l> <C-\><C-N><C-w>l
  tnoremap <Esc> <C-\><C-n>
]])

-- better indenting
map('v', '<', '<gv', {noremap = true, silent = true})
map('v', '>', '>gv', {noremap = true, silent = true})

-- I hate escape
map('i', 'jk', '<ESC>', {noremap = true, silent = true})
map('i', 'kj', '<ESC>', {noremap = true, silent = true})
map('i', 'jj', '<ESC>', {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
map('x', 'K', ':move \'<-2<CR>gv-gv', {noremap = true, silent = true})
map('x', 'J', ':move \'>+1<CR>gv-gv', {noremap = true, silent = true})

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')

-- resize windows
-- map('n', '<A-j>', ':resize -2', {noremap = true, silent = true})
-- map('n', '<A-k>', ':resize +2', {noremap = true, silent = true})
-- map('n', '<A-h>', ':vertical resize -2', {noremap = true, silent = true})
-- map('n', '<A-l>', ':vertical resize +2', {noremap = true, silent = true})

-- below are all plugin related mappings

local plugin_maps = {
   -- list open buffers up the top, easy switching too
   bufferline = {
      close_buffer = "<leader>x", -- close buffer
      -- next_buffer = "<TAB>", -- next buffer
      -- prev_buffer = "<S-Tab>", -- previous buffer
      -- tab is conflict with <C-i>
      next_buffer = "<C-t>", -- next buffer
      prev_buffer = "T", -- previous buffer
   },
   -- easily (un)comment code, language aware
   comment = {
      nor_toggle = "gcc", -- toggle comment (works on multiple lines) in normal mode
      vis_toggle = "gc", -- toggle comment (works on multiple lines) in visual mode
   },
   -- NeoVim 'home screen' on open
   dashboard = {
      bookmarks = "<leader>bm",
      new_file = "<leader>fn", -- basically create a new buffer
      open = "<leader>db", -- open dashboard
      session_load = "<leader>l", -- load a saved session
      session_save = "<leader>s", -- save a session
   },
   -- map to <ESC> with no lag
   better_escape = { -- <ESC> will still work
      esc_insertmode = { "jk" }, -- multiple mappings allowed
   },
   -- file explorer/tree
   nvimtree = {
      toggle = "<C-n>",
      focus = "<leader>e",
   },
   -- multitool for finding & picking things
   telescope = {
      buffers = "<leader>fb",
      find_files = "<leader>ff",
      find_hiddenfiles = "<leader>fa",
      git_commits = "<leader>cm",
      git_status = "<leader>gt",
      help_tags = "<leader>fh",
      live_grep = "<leader>fw",
      oldfiles = "<leader>fo",
      themes = "<leader>th", -- NvChad theme picker
      -- media previews within telescope finders
      telescope_media = {
         media_files = "<leader>fp",
      },
   },
}

local M = {}

M.bufferline = function()
   local m = plugin_maps.bufferline

   map("n", m.close_buffer, ":bdelete<CR>")
   map("n", m.next_buffer, ":BufferLineCycleNext <CR>")
   map("n", m.prev_buffer, ":BufferLineCyclePrev <CR>")
end

M.comment = function()
   local m = plugin_maps.comment
   map("n", m.nor_toggle, ":CommentToggle <CR>")
   map("v", m.vis_toggle, ":CommentToggle <CR>")
end

M.dashboard = function()
   local m = plugin_maps.dashboard

   map("n", m.bookmarks, ":DashboardJumpMarks <CR>")
   map("n", m.new_file, ":DashboardNewFile <CR>")
   map("n", m.open, ":Dashboard <CR>")
   map("n", m.session_load, ":SessionLoad <CR>")
   map("n", m.session_save, ":SessionSave <CR>")
end

M.nvimtree = function()
   map("n", plugin_maps.nvimtree.toggle, ":NvimTreeToggle <CR>")
   map("n", plugin_maps.nvimtree.focus, ":NvimTreeFocus <CR>")
end

M.telescope = function()
   local m = plugin_maps.telescope

   map("n", m.buffers, ":Telescope buffers <CR>")
   map("n", m.find_files, ":Telescope find_files <CR>")
   map("n", m.find_hiddenfiles, ":Telescope find_files hidden=true <CR>")
   map("n", m.git_commits, ":Telescope git_commits <CR>")
   map("n", m.git_status, ":Telescope git_status <CR>")
   map("n", m.help_tags, ":Telescope help_tags <CR>")
   map("n", m.live_grep, ":Telescope live_grep <CR>")
   map("n", m.oldfiles, ":Telescope oldfiles <CR>")
   map("n", m.themes, ":Telescope themes <CR>")
end

M.telescope_media = function()
   local m = plugin_maps.telescope.telescope_media

   map("n", m.media_files, ":Telescope media_files <CR>")
end

return M

