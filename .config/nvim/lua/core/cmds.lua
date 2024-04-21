-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby", "zig" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- setup some CMD
vim.cmd([[command! -nargs=0 GoToCommand :Telescope commands]])
vim.cmd([[command! -nargs=0 GoToFile :Telescope find_files]])
vim.cmd([[command! -nargs=0 Grep :Telescope live_grep]])
vim.cmd([[command! -nargs=0 SmartGoTo :Telescope find_files]])
