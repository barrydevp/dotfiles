local view = require("view")
local utils = require("utils")

local map = utils.map
local opt = { noremap = true }

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

-- Block movement
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '>-2<CR>gv=gv")

-- jumping
map("n", "g[", "<C-o>")
map("n", "g]", "<C-i>")

-- quicklist
map("n", "[q", ":cprev<CR>")
map("n", "]q", ":cnext<CR>")

-- buffer control buffer
map("n", "<leader>c", ":lua require('utils').close_buffer() <CR>") -- close  buffer
-- map("n", maps.close_buffer, ":lua require('bufdelete').bufdelete(0, true) <CR>") -- close  buffer
map("n", "<C-a>", ":%y+ <CR>") -- copy whole file content
map("n", "<C-n>b", ":enew <CR>") -- new buffer
map("n", "<C-n>t", ":tabnew <CR>") -- new tabs
map("n", "<C-s>", ":w <CR>") -- ctrl + s to save file

-- toggle numbers ---
map("n", "<leader>n", [[ <Cmd> set nu!<CR>]], opt)

map("n", "<C-s>", [[ <Cmd> w <CR>]], opt) -- save

-- Window nav
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<M-h>", ":vertical resize -2<CR>")
map("n", "<M-j>", ":resize -2<CR>")
map("n", "<M-k>", ":resize +2<CR>")
map("n", "<M-l>", ":vertical resize +2<CR>")

-- better split
-- map('n', '<leader>h', ':ls<cr> :vertical sb ', {})
map("n", "<leader>-", ":vsplit<CR>", {})
map("n", "<leader>_", ":split<CR>", {})

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

-- get out of terminal mode
map("t", "jk", "<C-\\><C-n>")
-- hide a term from within terminal mode
map("t", "JK", "<C-\\><C-n> :lua require('utils').close_buffer() <CR>")
-- pick a hidden term
map("n", "<leader>tf", ":Telescope terms <CR>")
-- Open terminals
-- TODO this opens on top of an existing vert/hori term, fixme
map("n", "<leader>tt", ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
map("n", "<leader>ty", ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")
map("n", "<leader>tn", ":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>")
-- terminal mappings end --

-- OPEN TERMINALS --
map("n", "<M-l>", [[<Cmd>vnew term://zsh <CR>]], opt) -- over right
map("n", "<M-j>", [[<Cmd> split term://zsh | resize 10 <CR>]], opt) --  bottom
map("n", "<C-n>t", [[<Cmd> tabnew | term <CR>]], opt) -- newtab
-- exit from terminal buffer
-- map("t", "<C-[><C-[>", "<C-\\><C-n>", {silent = true, noremap = true})

-- better indenting
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

-- I hate escape
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("i", "kj", "<ESC>", { noremap = true, silent = true })
map("i", "jj", "<ESC>", { noremap = true, silent = true })

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
map("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> ("\\<C-n>")')
vim.cmd('inoremap <expr> <c-k> ("\\<C-p>")')

-- command
map("n", "<C-p>", ":Telescope commands <CR>", { noremap = true, silent = true })

-- which key map
local wk_maps = {
	["q"] = { ":ccl<CR>", "Quit" },
	["c"] = "Close Buffer",
	["e"] = { ":NvimTreeToggle<CR>", "Explorer" },
	-- ["h"] = "No Highlight",
	l = {
		name = "LSP/LangServer",
		-- a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
		-- A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
		-- d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
		-- D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
		-- n = {"<cmd>Neoformat<cr>", "Neoformat"},
		f = "Format",
		z = { "<cmd>LspInfo<cr>", "Info" },
		-- L = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
		-- p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
		q = { "<cmd>Trouble quickfix<cr>", "Quickfix" },
		-- r = {"<cmd>Lspsaga rename<cr>", "Rename"},
		-- x = {"<cmd>cclose<cr>", "Close Quickfix"},
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
		t = { "<cmd>Trouble<cr>", "Show Diagnostics(Troubel)" },
		iw = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace diagnostics" },
		id = { "<cmd>Trouble document_diagnostics<cr>", "Document diagnostics" },
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
		h = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", "Hover" },
		k = { "<cmd>lua require('dap.ui.variables').hover()<cr>", "Hover" },
	},

	f = {
		name = "Telescope/Find",
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		F = { "<cmd>Telescope live_grep<cr>", "Live grep" },
		l = { "<cmd>Telescope live_grep<cr>", "Live grep" },
		t = { "<cmd>Telescope grep_string<cr>", "Find cursor string" },
		b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
		B = { "<cmd>Telescope file_browser<cr>", "File browser" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
		m = { "<cmd>Telescope marks<cr>", "Marks" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		g = { "<cmd>Telescope git_files<cr>", "Git files" },
		s = { "<cmd>Telescope resume<cr>", "Resume last search" },
		i = { "<cmd>Telescope lsp_implementations<cr>", "LSP Implementation" },
	},

	g = {
		name = "Git",
		co = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		f = { "<cmd>Telescope git_files<cr>", "Git files" },
		st = { "<cmd>Telescope git_status<cr>", "Git status" },
		cm = { "<cmd>Telescope git_commits<cr>", "Git commits" },
		cbm = { "<cmd>Telescope git_bcommits<cr>", "Git bcommits" },
		b = { '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', "Git blame line" },
		v = { "<cmd>GV<CR>", "Commit all" },
		u = { "Git UI" },
	},

	h = {
		name = "Git Hunks",
		b = "Blame",
		p = "Preview",
		r = "Reset",
		R = "Reset buffer",
		s = "Stage",
		S = "Reset buffer",
		u = "Undo staged",
		d = "Diff this",
		D = "Diff this ~",
	},
}

-- below are all plugin related mappings
local M = {}

M.wk_maps = wk_maps

M.git = function(bufnr)
	-- UI
	view.register("Git UI", {
		map = "<leader>gu",
		open = ":topleft vert Git",
		close = ":bd!",
		width = 40,
	})

	local gs = package.loaded.gitsigns

	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr

		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	map("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	-- Actions
	map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
	map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
	map("n", "<leader>hS", gs.stage_buffer)
	map("n", "<leader>hu", gs.undo_stage_hunk)
	map("n", "<leader>hR", gs.reset_buffer)
	map("n", "<leader>hp", gs.preview_hunk)
	map("n", "<leader>hb", function()
		gs.blame_line({ full = true })
	end)
	map("n", "<leader>tb", gs.toggle_current_line_blame)
	map("n", "<leader>hd", gs.diffthis)
	map("n", "<leader>hD", function()
		gs.diffthis("~")
	end)
	map("n", "<leader>td", gs.toggle_deleted)

	-- Text object
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

M.bufferline = function()
	-- map("n", m.close_buffer, ":bdelete<CR>")
	-- map("n", "<leader>x", ":lua require('bufdelete').bufdelete(0, true)<CR>")
	map("n", "<C-t>", ":BufferLineCycleNext <CR>")
	map("n", "T", ":BufferLineCyclePrev <CR>")
end

M.telescope_media = function()
	map("n", "<leader>fp", ":Telescope media_files <CR>")
end

M.lsp_config = function(bufnr)
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	map("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	map("n", "<leader>ld", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	map("n", "go", "<cmd>pop<CR>", opts)
	map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	map("n", "L", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- map("n", "gs", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	map("n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	map("n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	map("n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	-- map("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
	map("v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

return M
