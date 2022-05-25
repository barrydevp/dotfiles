local M = {}

M.get_capabilities = function()
    -- setup capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem = {
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

    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    return capabilities
end


M.lsp_handlers = function()
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

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
    })

    -- suppress error messages from lang servers
    vim.notify = function(msg, log_level)
        if msg:match "exit code" then
            return
        end
        if log_level == vim.log.levels.ERROR then
            vim.api.nvim_err_writeln(msg)
        else
            vim.api.nvim_echo({ { msg } }, true, {})
        end
    end

end

M.lsp_config = function(client, bufnr) 
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- mappings
    require("mappings").lsp_config()

end

M.on_attach = function(client, bufnr)
    M.lsp_config(client, bufnr)
end

return M
