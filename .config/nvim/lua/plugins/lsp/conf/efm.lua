-- efm.lua
local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintStdin = true,
}

local shellcheck = {
  lintCommand = "shellcheck -f gcc -x",
  lintSource = "shellcheck",
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
}
local shfmt = { formatCommand = "shfmt -ci -s -bn", formatStdin = true }

local luaformat = { formatCommand = "lua-format -i", formatStdin = true }

return {
  filetypes = {
    "sh",
    "lua",
    "css",
    "scss",
    "javascript",
    "typescript",
    "javascriptreact",
    "tpescriptreact",
  },
  init_options = { documentFormatting = true },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      lua = { luaformat },
      sh = { shellcheck, shfmt },
      css = { prettier },
      scss = { prettier },
      typescript = { prettier, eslint },
      javascript = { prettier, eslint },
      typescriptreact = { prettier, eslint },
      javascriptreact = { prettier, eslint },
    },
    javascript = { validate = true },
    javascriptreact = { validate = true },
    typescript = { validate = true },
    typescriptreact = { validate = true },
  },
}
