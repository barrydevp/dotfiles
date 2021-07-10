local M = {}

M.config = function()
    require "compe".setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = "enable",
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,
        source = {
            buffer = {kind = "﬘", true},
            luasnip = {kind = "﬌", true},
            nvim_lsp = true,
            nvim_lua = true
        }
    }

    -- local opt = {noremap = true, silent = true, expr=true}
    -- mappings
    -- vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", opt)
    vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", {expr = true})
    -- inoremap <silent><expr> <C-Space> compe#complete()
    -- inoremap <silent><expr> <CR>      compe#confirm('<CR>')
    -- inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    -- inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    -- inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
end

M.snippets = function()
    local ls = require("luasnip")

    ls.config.set_config(
        {
            history = true,
            updateevents = "TextChanged,TextChangedI"
        }
    )
    require("luasnip/loaders/from_vscode").load()
end

return M
