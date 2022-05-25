local lsp_utils = require("plugins.lsp.utils")
local lspconf = require("lspconfig")

lsp_utils.lsp_handlers()

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = {
    "html",
    "cssls",
    "tsserver",
    "pyright",
    "bashls",
    -- "gopls",
    "jdtls",
    "rust_analyzer",
}

local common_config = {
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.get_capabilities(),
    debounce_text_changes = 150,
}

for _, lang in ipairs(servers) do
    lspconf[lang].setup(common_config)
end

-- load specific lang server

-- lua
-- require "plugins.lsp.sumneko_lua"

-- vls
require "plugins.lsp.vls"

-- ccls
lspconf.ccls.setup(
    vim.tbl_extend(
        "force",
        common_config, 
        {
            init_options = {
                cache = { directory = "/tmp/ccls" }
            },
            -- root_dir = require('lspconfig/util').root_pattern("compile_commands.json", ".ccls", "compile_flags.txt", ".git") or os.getenv("PWD"),
        }
    )
)

lspconf.gopls.setup(
    vim.tbl_extend(
        "force",
        common_config, {
            cmd = {"gopls", "serve"},
            settings = {
              gopls = {
                analyses = {
                  composites = false,
                },
              },
            },
        }
    )
)
