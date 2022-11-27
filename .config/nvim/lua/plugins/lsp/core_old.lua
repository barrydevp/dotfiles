local M = {}

M.get_capabilities = function()
	-- setup capabilities
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

	vim.diagnostic.config({
		virtual_text = {
			source = "always",
			prefix = "■",
			-- Only show virtual text matching the given severity
			severity = {
				-- Specify a range of severities
				min = vim.diagnostic.severity.ERROR,
			},
		},
		float = {
			source = "always",
			border = "rounded",
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,

		-- virtual_text = {
		--     prefix = "",
		-- },
		-- signs = true,
		-- underline = true,
		-- update_in_insert = false,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
	vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
	vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
	vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
	vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
	vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
	vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
	vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler

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
end

M.lsp_config = function(client, bufnr)
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- -- mappings
	-- require("mappings").lsp_config()
end

M.on_attach = function(client, bufnr)
	M.lsp_config(client, bufnr)
end

M.common_config = {
	on_attach = M.on_attach,
	capabilities = M.get_capabilities(),
	debounce_text_changes = 150,
}

M.extend_config = function(config)
	return vim.tbl_extend("force", M.common_config, config)
end

return M
