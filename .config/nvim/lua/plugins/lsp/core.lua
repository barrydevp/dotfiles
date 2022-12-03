local M = {}
-- export on_attach & capabilities for custom lspconfigs

M.ui = function()
  local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  lspSymbol("Error", "")
  lspSymbol("Info", "")
  lspSymbol("Hint", "")
  lspSymbol("Warn", "")

  vim.diagnostic.config {
    virtual_text = {
      prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  }

  -- suppress error messages from lang servers
  vim.notify = function(msg, log_level)
    if msg:match("exit code") then
      return
    end
    if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end

  -- Borders for LspInfo winodw
  local win = require("lspconfig.ui.windows")
  local _default_opts = win.default_opts

  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end
end

M.handlers = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    focusable = false,
    relative = "cursor",
  })

  -- vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
  -- vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
  -- vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
  -- vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
  -- vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
  -- vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
  -- vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
  -- vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
end

M.lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    async = false,
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      -- return client.name == "null-ls"
      return client.name ~= "tsserver"
    end,
    bufnr = bufnr,
  }
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.nullls = function()
  require("plugins.configs.nullls")
end

M.on_attach = function(client, bufnr)
  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.documentRangeFormattingProvider = false

  -- auto formatting when save
  -- if client.supports_method("textDocument/formatting") then
  --   vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     group = augroup,
  --     buffer = bufnr,
  --     callback = function()
  --       M.lsp_formatting(bufnr)
  --     end,
  --   })
  -- end

  require("utils.mapping").load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
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
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    -- debounce_text_changes = 150,
  }

  require("lspconfig")[lang].setup(common_config)
end

return M
