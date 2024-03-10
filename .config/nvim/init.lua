local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- load and init core
require("core")

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").lazy(lazypath)
end

vim.opt.rtp:prepend(lazypath)
require("plugins")
