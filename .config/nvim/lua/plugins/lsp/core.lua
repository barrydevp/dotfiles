local utils = require("core.utils")

local M = {}
-- export on_attach & capabilities for custom lspconfigs

M.handlers = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    focusable = false,
    relative = "cursor",
  })
end

M.lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    async = true,
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      -- return client.name == "null-ls"
      return client.name ~= "tsserver"
    end,
    bufnr = bufnr,
  }
end

-- if you want to set up formatting on save, you can use this as a callback
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.nullls = function()
  require("plugins.configs.nullls")
end

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

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
