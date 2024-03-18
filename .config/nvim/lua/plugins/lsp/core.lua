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

M.daps = {
  "codelldb",
}

M.linters = {
  "eslint_d",
}

M.formatters = {
  "stylua",
  "prettierd",
  "isort",
  "shfmt",
  "goimports",
  "gofumpt",
}

M.format = function(bufnr)
  local conform = require("conform")
  conform.format {
    lsp_fallback = true,
    async = true,
    timeout_ms = 500,
  }
end

M.renamer = function()
  require("plugins.lsp.ui.renamer").open()
end

M.signature = function()
  vim.lsp.buf.signature_help()
end

M.parameter_hints = function()
  vim.lsp.buf.signature_help()
  require("plugins.lsp.ui.signature").parameter_hints()
end

M.on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("plugins.lsp.ui.signature").setup(client)
  end
end

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
    on_init = M.on_init,
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  }

  require("lspconfig")[lang].setup(common_config)
end

return M
