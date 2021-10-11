-- lsp saga

local saga = require('lspsaga')
local lspsaga_cfg = {
-- default value
-- use_saga_diagnostic_sign = true
-- error_sign = '?',
-- warn_sign = '?',
-- hint_sign = '?',
-- infor_sign = '?',
-- dianostic_header_icon = ' ?  ',
-- code_action_icon = '? ',
-- code_action_prompt = {
--   enable = true,
--   sign = true,
--   sign_priority = 20,
--   virtual_text = true,
-- },
-- finder_definition_icon = '?  ',
-- finder_reference_icon = '?  ',
-- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
-- finder_action_keys = {
--   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
-- },
-- code_action_keys = {
--   quit = 'q',exec = '<CR>'
-- },
-- rename_action_keys = {
--   quit = '<C-c>',exec = '<CR>'  -- quit can be a table
-- },
-- definition_preview_icon = '?  '
-- "single" "double" "round" "plus"
-- border_style = "single"
-- rename_prompt_prefix = '?',
-- if you don't use nvim-lspconfig you must pass your server name and
-- the related filetypes into this table
-- like server_filetype_map = {metals = {'sbt', 'scala'}}
-- server_filetype_map = {}
}

-- for custom config
-- saga.init_lsp_saga(lspsaga_cfg)
-- for default
saga.init_lsp_saga()
vim.cmd[[au VimEnter * highlight ColorColumn guibg=#171717]]

-- remap unused
local function map(mode, lhs, rhs, options)
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local basic_opts = {noremap = true, silent = true}
map("n", "H", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", basic_opts)
map("n", "gs", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", basic_opts)
map("n", "K", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", basic_opts)
-- map("n", "gi", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", basic_opts)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", basic_opts)
map("n", "gt", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", basic_opts)
map("n", "<leader>lr", "<cmd>lua require('lspsaga.rename').rename()<CR>", basic_opts)
map("n", "<leader>la", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", basic_opts)
map("v", "<leader>la", ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", basic_opts)
map("n", "gl", "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", basic_opts)
map("n", "[d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", basic_opts)
map("n", "]d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", basic_opts)



-- replace the default lsp diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

local lspconfig = {}
-- lsp signature config
local lspsignature_cfg = {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                 -- set to 0 if you DO NOT want any API comments be shown
                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                 -- mode, 10 by default

  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter
  hint_scheme = "String",
  use_lspsaga = false,  -- set to true if you want to use lspsaga popup
  hi_parameter = "Search", -- how your parameter will be highlight
  max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                   -- to view the hiding contents
  max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "double"   -- double, single, shadow, none
  },

  trigger_on_newline = true, -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  -- deprecate !!
  -- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
  zindex = 50, -- by default it will be on top of all floating windows, set to 50 send it to bottom
  debug = false, -- set to true to enable debug logging
  log_path = "debug_log_file_path", -- debug log path

  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = "#c882e7", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}

function lspconfig.on_attach(client)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- setup lsp signature
    require "lsp_signature".on_attach(lspsignature_cfg, bufnr)

    -- Mappings.
    local opts = {noremap = true, silent = true}

    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- buf_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    -- buf_set_keymap("n", "H", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- buf_set_keymap("n", "gl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    -- buf_set_keymap("n", "gs", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    -- buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    -- buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    -- buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    -- buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    -- buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    -- buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local lspconf = require("lspconfig")

-- these langs require same lspconfig so put em all in a table and loop through!
local servers = {
    "html",
    "cssls",
    "tsserver",
    "pyright",
    "bashls",
    -- "clangd",
    "ccls",
    "gopls",
    "jdtls",
}

for _, lang in ipairs(servers) do
    lspconf[lang].setup {
        on_attach = lspconfig.on_attach,
        root_dir = vim.loop.cwd
    }
end

-- load lang server
-- require "plugins.lsp.sumneko_lua"
require "plugins.lsp.vls"

return lspconfig

