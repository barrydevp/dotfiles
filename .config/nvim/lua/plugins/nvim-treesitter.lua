local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    highlight = {
        enable = true,
        use_languagetree = true,
        -- additional_vim_regex_highlighting = false,
    }
}
local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

local default = {
   ensure_installed = {
      "lua",
      "vim",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "scss",
      "bash",
      "json",
      "python",
      "go",
      "gomod",
      "yaml",
      "toml",
      "dockerfile",
      "java",
      "c",
      "cpp",
      "c_sharp",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}

local M = {}
M.setup = function(override_flag)
   ts_config.setup(default)
end

M.setup()

return M
