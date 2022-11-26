-- lua lsp settings
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"

if is_windows then
  return
end

local core = require("plugins.lsp.core")

USER = (vim.fn.has("macunix") and "/Users/" or "/home/") .. vim.fn.expand("$USER")

local sumneko_root_path = USER .. "/.local/lang-server/lua-language-server"
local sumneko_binary = USER .. "/.local/lang-server/lua-language-server/bin/lua-language-server"

-- lsp_utils.extend_config({
--     cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
--     root_dir = function()
--         return vim.loop.cwd()
--     end,
--     settings = {
--         Lua = {
--             format = {
--                 enable = true,
--             },
--             runtime = {
--                 version = "LuaJIT",
--                 path = vim.split(package.path, ";")
--             },
--             diagnostics = {
--                 globals = { "vim" }
--             },
--             workspace = {
--                 library = {
--                     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--                     [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
--                 },
--                 maxPreload = 100000,
--                 preloadFileSize = 10000,
--             },
--             telemetry = {
--                 enable = false
--             }
--         }
--     }
-- })

require("lspconfig").sumneko_lua.setup {
  on_attach = core.on_attach,
  capabilities = core.capabilities,

  cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
  root_dir = function()
    return vim.loop.cwd()
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
