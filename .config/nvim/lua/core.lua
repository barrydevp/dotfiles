local api = vim.api
local utils = require("utils")
local map = utils.map

-- The initial state of a tab
local tabinitial = {
	-- True if help is displayed
	help = false,
	-- The position of the cursor { line, column }
	cursor = { 0, 0 },
	-- The View window number
	winnr = nil,
	-- The View buffer number
	bufnr = nil,
}

local M = {
	View = {},
}

function M.is_visible(name)
	local winnr = M.get_winnr(name)
	return winnr ~= nil and api.nvim_win_is_valid(winnr)
end

function M.get_tabinfo(name, tabpage)
	tabpage = tabpage or api.nvim_get_current_tabpage()
	local view = M.View[name]
	local tabinfo = view and view.tabpages[tabpage]
	return tabinfo
end

function M.get_winnr(name, tabpage)
	local tabinfo = M.get_tabinfo(name, tabpage)
	if tabinfo ~= nil then
		return tabinfo.winnr
	end
end

-- save_tab_state saves any state that should be preserved across redraws.
function save_tab_state(name)
	local tabpage = api.nvim_get_current_tabpage()
	local view = M.View[name]
	if view == nil then
		return
	end

	view.cursors[tabpage] = api.nvim_win_get_cursor(M.get_winnr(name))
end

function M.create_buffer(name)
	local view = M.View[name]
	-- open command
	local command = view.opts.open
	if view.opts.width then
		command = command .. " | vertical resize " .. view.opts.width .. " | set winfixwidth"
	end
	vim.cmd(command)

	-- save the winnr
	local tabpage = api.nvim_get_current_tabpage()
	local winnr = api.nvim_get_current_win()
	local bufnr = api.nvim_get_current_buf()

	view.tabpages[tabpage] =
		vim.tbl_extend("force", view.tabpages[tabpage] or tabinitial, { winnr = winnr, bufnr = bufnr })
end

function M.close_buffer(name)
	-- save_tab_state()
	local tabinfo = M.get_tabinfo(name)
	local winnr = tabinfo.winnr
	local bufnr = tabinfo.bufnr
	api.nvim_set_current_win(winnr)

	-- open command
	vim.cmd(M.View[name].opts.close)
	if api.nvim_win_is_valid(winnr) then
		api.nvim_win_close(winnr, true)
	end
	if api.nvim_buf_is_loaded(bufnr) then
		vim.cmd("bd! " .. bufnr)
	end

	-- M.View[name].tabpages = {}
end

function M.toggle(name)
	if M.is_visible(name) then
		M.close_buffer(name)
		return
	end

	M.create_buffer(name)
end

function M.register(name, opts)
	if not name or not opts or not opts.map or not opts.open then
		return
	end

	opts.close = opts.close or "q"

	map("n", opts.map, ':lua require("core").toggle("' .. name .. '")<CR>')

	M.View[name] = {
		tabpages = {},
		opts = opts,
	}
end

return M
