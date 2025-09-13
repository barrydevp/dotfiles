local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  require("core.bootstrap").lazy(lazypath)
end
vim.opt.rtp:prepend(lazypath)

-- load and init core
require("core")

-- load plugins
require("plugins")

if vim.g.vscode then
  require("vs_code")
end

