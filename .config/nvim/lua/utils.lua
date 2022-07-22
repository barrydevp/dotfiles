local M = {}

M.boot_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })

	if fn.empty(fn.glob(install_path)) > 0 then
		print("Cloning packer ..")
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

		-- install plugins + compile their configs
		vim.cmd("packadd packer.nvim")
		require("plugins")
		vim.cmd("PackerSync")
	end
end

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
	local close_cmd = force and ":bd!" or ":bp | bd " .. vim.fn.bufnr()
	vim.cmd(close_cmd)
end

-- wrapper key map
M.map = function(mode, keys, command, opt)
	local options = { silent = true }

	if opt then
		options = vim.tbl_extend("force", options, opt)
	end

	if type(keys) == "table" then
		for _, keymap in ipairs(keys) do
			M.map(mode, keymap, command, options)
		end
		return
	end

	vim.keymap.set(mode, keys, command, options)
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

M.load_plugins = function(name)
	local default_path = "plugins.configs." .. name

	local ok, _module = pcall(require, default_path)

	if ok then
		print("load ok " .. name)
		return _module
	else
		error("No such plugin config " .. name)
	end
end

return M
