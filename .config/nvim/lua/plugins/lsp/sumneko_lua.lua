local lsp_utils = require("plugins.lsp.utils")

-- lua lsp settings

USER = (vim.fn.has('macunix') and "/Users/" or "/home/") .. vim.fn.expand("$USER")

local sumneko_root_path = USER .. "/.local/lang-server/lua-language-server"
local sumneko_binary = USER .. "/.local/lang-server/lua-language-server/bin/lua-language-server"

return lsp_utils.extend_config({
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    root_dir = function()
        return vim.loop.cwd()
    end,
    settings = {
        Lua = {
            format = {
                enable = true,
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";")
            },
            diagnostics = {
                globals = { "vim" }
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false
            }
        }
    }
})
