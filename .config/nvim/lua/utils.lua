local M = {}

local merge_tb = vim.tbl_deep_extend

M.close_buffer = function(force)
	if vim.bo.buftype == "terminal" then
		vim.api.nvim_win_hide(0)
		return
	end

	local fileExists = vim.fn.filereadable(vim.fn.expand("%p"))
	local modified = vim.api.nvim_buf_get_option(vim.fn.bufnr(), "modified")

	-- if file doesnt exist & its modified
	if fileExists == 0 and modified then
		print("no file name? add it now!")
		return
	end

	force = force or not vim.bo.buflisted or vim.bo.buftype == "nofile"

	-- if not force, change to prev buf and then close current
	local close_cmd = force and ":bd!" or ":bp | bd" .. vim.fn.bufnr()
	vim.cmd(close_cmd)
end

-- reduces a given keymap to a table of modes each containing a list of key maps
M.reduce_key_map = function(key_map, ignore_modes)
	local prune_keys = {}

	for _, modes in pairs(key_map) do
		for mode, mappings in pairs(modes) do
			if not vim.tbl_contains(ignore_modes, mode) then
				prune_keys[mode] = prune_keys[mode] and prune_keys[mode] or {}
				prune_keys[mode] = vim.list_extend(prune_keys[mode], vim.tbl_keys(mappings))
			end
		end
	end
	return prune_keys
end

-- remove disabled mappings from a given key map
M.remove_disabled_mappings = function(key_map)
	local clean_map = {}

	if key_map == nil or key_map == "" then
		return key_map
	end

	if type(key_map) == "table" then
		for k, v in pairs(key_map) do
			if v ~= nil and v ~= "" then
				clean_map[k] = v
			end
		end
	end

	return clean_map
end

-- prune keys from a key map table by matching against another key map table
M.prune_key_map = function(key_map, prune_map, ignore_modes)
	if not prune_map then
		return key_map
	end
	if not key_map then
		return prune_map
	end
	local prune_keys = type(prune_map) == "table" and M.reduce_key_map(prune_map, ignore_modes)
		or { n = {}, v = {}, i = {}, t = {} }

	for ext, modes in pairs(key_map) do
		for mode, mappings in pairs(modes) do
			if not vim.tbl_contains(ignore_modes, mode) then
				-- filter mappings table so that only keys that are not in user_mappings are left
				for b, _ in pairs(mappings) do
					if prune_keys[mode] and vim.tbl_contains(prune_keys[mode], b) then
						key_map[ext][mode][b] = nil
					end
				end
			end
			key_map[ext][mode] = M.remove_disabled_mappings(mappings)
		end
	end

	return key_map
end

-- wrapper key map
M.map = function(mode, keys, command, opt)
	local options = { silent = true }

	if opt then
		options = vim.tbl_extend("force", options, opt)
	end

	if type(keys) == "table" then
		for _, keymap in ipairs(keys) do
			M.map(mode, keymap, command, opt)
		end
		return
	end

	vim.keymap.set(mode, keys, command, opt)
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
	if plugin then
		timer = timer or 0
		vim.defer_fn(function()
			require("packer").loader(plugin)
		end, timer)
	end
end

-- my custom function

M.get_colors = function(theme_name)
	local custom_theme = theme_name or vim.g.custom_theme or "github"
	local theme_module = "themes." .. custom_theme
	local theme = require(theme_module)

	return theme.colors
end

M.get_theme = function(theme_name)
	local custom_theme = theme_name or vim.g.custom_theme or "github"
	local theme_module = "themes." .. custom_theme
	local theme = require(theme_module)

	return theme.base
end

return M
