require("plugins.others").lsp_handlers()

local function on_attach(_, bufnr)
   local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
   end
   local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
   end

   -- Enable completion triggered by <c-x><c-o>
   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

   -- Mappings.
   local opts = { noremap = true, silent = true }

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
   buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
   buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
   -- buf_set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
   buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
   buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
   buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
   buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
   buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
   buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
   buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
   buf_set_keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
   buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
   buf_set_keymap("n", "<leader>ge", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
   buf_set_keymap("n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
   buf_set_keymap("n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
   -- buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
   buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
   buf_set_keymap("v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

local lspconf = require("lspconfig")

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = {
    "html",
    "cssls",
    "tsserver",
    "pyright",
    "bashls",
    -- "gopls",
    "jdtls",
}

local common_config = {
    on_attach = on_attach,
    capabilities = capabilities,
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
