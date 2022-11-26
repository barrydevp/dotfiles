local ok, null_ls = pcall(require, "null-ls")

if not ok then
	return
end

local lsp_core = require("plugins.lsp.core")

local builtins = null_ls.builtins

local sources = {
	-- Diagnostics
	builtins.diagnostics.eslint_d,
	-- builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

    -- Format
    builtins.formatting.prettierd.with({
        -- filetypes = { "html", "json", "markdown", "scss", "css" },
        prefer_local = "node_modules/.bin",
    }),
	builtins.formatting.shfmt,
	builtins.formatting.stylua,
	builtins.formatting.autopep8,

	-- Code actions
	builtins.code_actions.eslint_d,
}

null_ls.setup({
	sources = sources,
	on_attach = lsp_core.on_attach,
	debounce = 150,
})
