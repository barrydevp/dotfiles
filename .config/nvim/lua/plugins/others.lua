local M = {}

M.base46 = function()
    local ok, base46 = pcall(require, "base46")
    if ok then
        base46.load_theme("rxyhn")
        -- base46.load_theme("radium")
    end
end

M.autopairs = function()
    local present1, autopairs = pcall(require, "nvim-autopairs")
    -- local present2, autopairs_completion = pcall(require, "nvim-autopairs.completion.cmp")
    local present2, autopairs_completion = pcall(require, "cmp")

    if not (present1 or present2) then
        return
    end

    autopairs.setup()
    autopairs_completion.setup {
        map_complete = true, -- insert () func completion
        map_cr = true,
    }
end

M.better_escape = function()
    require("better_escape").setup {}
end


M.blankline = function()
    local present, blankline = pcall(require, "indent_blankline")

    if not present then
        return
    end

    vim.cmd([[
        if &diff
            let g:indent_blankline_enabled = v:false
        endif
    ]])

    vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

    vim.opt.list = true
    vim.opt.listchars:append("space:⋅")
    vim.opt.listchars:append("eol:↴")

    local options = {
        indentLine_enabled = 1,
        char = "▏", -- '│'
        context_char = "▏", -- '│'
        filetype_exclude = {
            "vimwiki",
            "man",
            "diagnosticpopup",
            "lspinfo",
            "markdown", "WhichKey",
            --
            "help",
            "terminal",
            "alpha",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "lsp-installer",
            "",
        },
        buftype_exclude = { "terminal" },
        context_patterns = {
            "class",
            "function",
            "func_literal",
            "method",
            "^if",
            "while",
            "for",
            "with",
            "try",
            "except",
            "argument_list",
            "object",
            "dictionary",
            "element",
        },
        context_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        },
        space_char_blankline = " ",
        use_treesitter = true,
        show_current_context = true,
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        show_foldtext = false,
        strict_tabs = true,
        max_indent_increase = 1,
    }

    blankline.setup(options)
end

M.colorizer = function()
    local present, colorizer = pcall(require, "colorizer")
    if present then
        colorizer.setup({ "*" }, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

            -- Available modes: foreground, background
            mode = "background", -- Set the display mode.
        })
        vim.cmd "ColorizerReloadAllBuffers"
    end
end

M.comment = function(override_flag)
    local present, nvim_comment = pcall(require, "Comment")
    if present then
        local default = {}
        nvim_comment.setup(default)
    end
end

M.luasnip = function(override_flag)
    local present, luasnip = pcall(require, "luasnip")
    if present then
        local default = {
            history = true,
            updateevents = "TextChanged,TextChangedI",
        }
        if override_flag then
            default = require("core.utils").tbl_override_req("luasnip", default)
        end
        luasnip.config.set_config(default)
        -- require("luasnip/loaders/from_vscode").load { paths = chadrc_config.plugins.options.luasnip.snippet_path }
        require("luasnip/loaders/from_vscode").load()
    end
end

M.signature = function(override_flag)
    local present, lspsignature = pcall(require, "lsp_signature")
    if present then
        local default = {
            bind = true,
            doc_lines = 0,
            floating_window = true,
            fix_pos = true,
            hint_enable = true,
            hint_prefix = " ",
            hint_scheme = "String",
            hi_parameter = "Search",
            max_height = 22,
            max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
            handler_opts = {
                border = "single", -- double, single, shadow, none
            },
            zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
            padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
        }
        lspsignature.setup(default)
    end
end

M.gitsigns = function(override_flag)
    local present, gitsigns = pcall(require, "gitsigns")
    if present then
        local default = {
            signs = {
                add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
                change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
                delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
                topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
                changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
            },
        }
        if override_flag then
            default = require("core.utils").tbl_override_req("gitsigns", default)
        end
        gitsigns.setup(default)
    end
end

M.dapui = function()
    require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
        },
        layouts = {
            -- You can change the order of elements in the sidebar
            {
                elements = {
                    -- Provide as ID strings or tables with "id" and "size" keys
                    {
                        id = "scopes",
                        size = 0.4, -- Can be float or integer > 1
                    },
                    { id = "breakpoints", size = 0.2 },
                    { id = "stacks", size = 0.2 },
                    { id = "watches", size = 0.2 },
                },
                size = 56,
                position = "left", -- Can be "left", "right", "top", "bottom"
            },
            {
                elements = { "repl" },
                size = 10,
                position = "bottom", -- Can be "left", "right", "top", "bottom"
            }
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
    })
end

M.markdown = function()
    vim.g.mkdp_open_to_the_world = 1
    vim.g.mkdp_port = '30000'
end

return M
