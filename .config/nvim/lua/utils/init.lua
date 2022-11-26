local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.boot_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })

  if fn.empty(fn.glob(install_path)) > 0 then
    print("Cloning packer ..")
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }

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
M.map = function(mode, keys, cmd, opt)
  local options = { noremap = true, silent = true }
  if opt then
    options = vim.tbl_extend("force", options, opt)
  end

  -- all valid modes allowed for mappings
  -- :h map-modes
  local valid_modes = {
    [""] = true,
    ["n"] = true,
    ["v"] = true,
    ["s"] = true,
    ["x"] = true,
    ["o"] = true,
    ["!"] = true,
    ["i"] = true,
    ["l"] = true,
    ["c"] = true,
    ["t"] = true,
  }

  -- helper function for M.map
  -- can gives multiple modes and keys
  local function map_wrapper(_mode, lhs, rhs, _options)
    if type(lhs) == "table" then
      for _, key in ipairs(lhs) do
        map_wrapper(_mode, key, rhs, _options)
      end
    else
      if type(_mode) == "table" then
        for _, m in ipairs(_mode) do
          map_wrapper(m, lhs, rhs, _options)
        end
      else
        if valid_modes[_mode] and lhs and rhs then
          vim.api.nvim_set_keymap(_mode, lhs, rhs, _options)
        else
          _mode, lhs, rhs = _mode or "", lhs or "", rhs or ""
          print("Cannot set mapping [ mode = '" .. _mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]")
        end
      end
    end
  end

  map_wrapper(mode, keys, cmd, options)
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

-- require("packer").loader(tb.plugins)
-- This must be used for plugins that need to be loaded just after a file
-- ex : treesitter, lspconfig etc
M.lazy_load = function(tb)
  autocmd(tb.events, {
    group = vim.api.nvim_create_augroup(tb.augroup_name, {}),
    callback = function()
      if tb.condition() then
        vim.api.nvim_del_augroup_by_name(tb.augroup_name)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if tb.plugin ~= "nvim-treesitter" then
          vim.defer_fn(function()
            require("packer").loader(tb.plugin)
            if tb.plugin == "nvim-lspconfig" then
              vim.cmd("silent! do FileType")
            end
          end, 0)
        else
          require("packer").loader(tb.plugin)
        end
      end
    end,
  })
end

M.is_windows = vim.loop.os_uname().sysname == "Windows_NT"

return M
