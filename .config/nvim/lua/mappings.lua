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
-- map("n", maps.close_buffer, ":lua require('bufdelete').bufdelete(0, true) <CR>") -- close  buffer
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
--
-- which key map

local wk_maps = {
    ["c"] = "Close Buffer",
    ["e"] = {":NvimTreeToggle<CR>", "Explorer"},
    ["h"] = "No Highlight",
    l = {
        name = "LSP/LangServer",
        -- a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
        -- A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
        -- d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        -- D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        -- n = {"<cmd>Neoformat<cr>", "Neoformat"},
        f = "Format",
        z = {"<cmd>LspInfo<cr>", "Info"},
        -- L = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
        -- p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
        q = {"<cmd>Telescope quickfix<cr>", "Quickfix"},
        -- r = {"<cmd>Lspsaga rename<cr>", "Rename"},
        -- x = {"<cmd>cclose<cr>", "Close Quickfix"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"},
        i = {"<cmd>Trouble<cr>", "Show Diagnostics(Troubel)"},
        iw = {"<cmd>Trouble lsp_workspace_diagnostics<cr>", "Workspace diagnostics"},
        id = {"<cmd>Trouble lsp_document_diagnostics<cr>", "Document diagnostics"},
    },

    d = {
        name = "Debug",
        t = {
            "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
            "Toggle Breakpoint",
        },
        d = {
            "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
            "Toggle Breakpoint",
        },
        b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
        s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
        r = { "<cmd>lua require'dap'.continue()<cr>", "Rerun" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        -- n = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        n = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
        p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
        q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        e = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over(End)" },
        o = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
        C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
        D = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
        g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
        R = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
        h = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", "Hover"},
        k = { "<cmd>lua require('dap.ui.variables').hover()<cr>", "Hover"},
    },

    f = {
        name = "Telescope/Find",
        f = {"<cmd>Telescope find_files<cr>", "Find File"},
        F = {"<cmd>Telescope live_grep<cr>", "Live grep"},
        t = {"<cmd>Telescope grep_string<cr>", "Find cursor string"},
        b = {"<cmd>Telescope buffers<cr>", "Find buffers"},
        B = {"<cmd>Telescope file_browser<cr>", "File browser"},
        h = {"<cmd>Telescope help_tags<cr>", "Help tags"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        R = {"<cmd>Telescope registers<cr>", "Registers"},
        c = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        g = {"<cmd>Telescope git_files<cr>", "Git files"},
    },

    g = {
        name = "Git",
        co = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        f = {"<cmd>Telescope git_files<cr>", "Git files"},
        st = {"<cmd>Telescope git_status<cr>", "Git status"},
        cm = {"<cmd>Telescope git_commits<cr>", "Git commits"},
        cbm = {"<cmd>Telescope git_bcommits<cr>", "Git bcommits"},
        n = {'<cmd>lua require"gitsigns".next_hunk()<CR>', 'Next hunk'},
        p = {'<cmd>lua require"gitsigns".prev_hunk()<CR>', 'Previous hunk'},
        h = {'<cmd>lua require"gitsigns".preview_hunk()<CR>', 'Git preview hunk'},
        bl = {'<cmd>lua require"gitsigns".blame_line{full=true}<CR>', 'Git blame line'},
    },

    -- s = {
    --     name = "+Search",
    --     b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
    --     c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
    --     d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
    --     D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
    --     f = {"<cmd>Telescope find_files<cr>", "Find File"},
    --     m = {"<cmd>Telescope marks<cr>", "Marks"},
    --     M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
    --     r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
    --     R = {"<cmd>Telescope registers<cr>", "Registers"},
    --     t = {"<cmd>Telescope live_grep<cr>", "Text"}
    -- },
}

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

M.wk_maps = wk_maps

M.bufferline = function()
   local m = plugin_maps.bufferline

   -- map("n", m.close_buffer, ":bdelete<CR>")
   map("n", m.close_buffer, ":lua require('bufdelete').bufdelete(0, true)<CR>")
   map("n", m.next_buffer, ":BufferLineCycleNext <CR>")
   map("n", m.prev_buffer, ":BufferLineCyclePrev <CR>")
end

M.comment = function()
   local m = plugin_maps.comment
   -- map("n", m.nor_toggle, ":CommentToggle <CR>")
   -- map("v", m.vis_toggle, ":CommentToggle <CR>")
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

M.lsp_config = function()
   local opts = { noremap = true, silent = true }

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
   map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
   map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
   -- map("n", "gs", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
   map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
   map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
   map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
   map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
   map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
   map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
   map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
   map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
   map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
   map("n", "<leader>ge", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
   map("n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
   map("n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
   -- map("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
   map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
   map("v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

return M

