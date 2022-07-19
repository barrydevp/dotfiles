local present, luasnip = pcall(require, "luasnip")

if not present then
	return
end

local default = {
	history = true,
	updateevents = "TextChanged,TextChangedI",
}

luasnip.config.set_config(default)
require("luasnip/loaders/from_vscode").load()
