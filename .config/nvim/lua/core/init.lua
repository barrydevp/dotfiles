-- -- disable some builtin vim plugins
-- local default_plugins = {
--   "2html_plugin",
--   "getscript",
--   "getscriptPlugin",
--   "gzip",
--   "logipat",
--   "netrw",
--   "netrwPlugin",
--   "netrwSettings",
--   "netrwFileHandlers",
--   "matchit",
--   "tar",
--   "tarPlugin",
--   "rrhelper",
--   "spellfile_plugin",
--   "vimball",
--   "vimballPlugin",
--   "zip",
--   "zipPlugin",
--   "tutor",
--   "rplugin",
--   "syntax",
--   "synmenu",
--   "optwin",
--   "compiler",
--   "bugreport",
--   "ftplugin",
-- }
--
-- for _, plugin in pairs(default_plugins) do
--   g["loaded_" .. plugin] = 1
-- end

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

require("core.options")
-- require("core.indents")

-------------------------------------- commands ------------------------------------------
local new_cmd = vim.api.nvim_create_user_command

new_cmd("ChangeTheme", function(opts)
  require("utils.init").reload_theme(opts.args)
end, {})
