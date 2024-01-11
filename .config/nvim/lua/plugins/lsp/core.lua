local utils = require("core.utils")

local M = {}
-- export on_attach & capabilities for custom lspconfigs

M.servers = {
  "lua_ls",
  "vls",
  -- "ccls",
  "clangd",
  "html",
  "cssls",
  "tsserver",
  "pyright",
  "bashls",
  "gopls",
  "jdtls",
  "rust_analyzer",
}

M.lsp_formatting = function(bufnr)
  -- if bufnr == nil then
  --   bufnr = vim.api.nvim_get_current_buf()
  -- end
  -- local null_ls_sources = require("null-ls.sources")
  -- local ft = vim.bo[bufnr].filetype
  --
  -- local has_null_ls = #null_ls_sources.get_available(ft, "NULL_LS_FORMATTING") > 0
  --
  -- vim.lsp.buf.format {
  --   async = true,
  --   bufnr = bufnr,
  --   filter = function(client)
  --     if has_null_ls then
  --       return client.name == "null-ls"
  --     else
  --       return true
  --     end
  --   end,
  -- }

  local conform = require("conform")
  conform.format {
    lsp_fallback = true,
    async = true,
    timeout_ms = 500,
  }
end

-- if you want to set up formatting on save, you can use this as a callback
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.nullls = function()
  require("plugins.configs.nullls")
end

M.on_attach = function(client, bufnr)
  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.setup_default = function(lang)
  local common_config = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    -- debounce_text_changes = 150,
  }

  require("lspconfig")[lang].setup(common_config)
end

return M
