require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ...  motions = true, -- adds help for motions text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

-- vim.api.nvim_set_keymap('n', ',', '<NOP>', {noremap = true, silent = true})
-- vim.g.mapleader = ','

-- no hl
-- vim.api.nvim_set_keymap('n', '<leader>h', ':nohl<CR>', {noremap = true, silent = true})

-- explorer
-- vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

-- telescope
-- vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<CR>', {noremap = true, silent = true})

-- close buffer
-- vim.api.nvim_set_keymap("n", "<leader>c", ":bdelete<CR>", {noremap = true, silent = true})

-- TODO create entire treesitter section

local mappings = {
    ["c"] = "Close Buffer",
    ["e"] = {":NvimTreeToggle<CR>", "Explorer"},
    ["h"] = "No Highlight",
    l = {
        name = "LSP/LangServer",
        -- a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
        -- A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
        -- d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        -- D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        -- n = {"<cmd>Neoformat<cr>", "Neoformat"},
        f = "Format",
        z = {"<cmd>LspInfo<cr>", "Info"},
        -- L = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
        -- p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
        q = {"<cmd>Telescope quickfix<cr>", "Quickfix"},
        -- r = {"<cmd>Lspsaga rename<cr>", "Rename"},
        -- x = {"<cmd>cclose<cr>", "Close Quickfix"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"},
        i = {"<cmd>Trouble<cr>", "Show Diagnostics(Troubel)"},
        iw = {"<cmd>Trouble lsp_workspace_diagnostics<cr>", "Workspace diagnostics"},
        id = {"<cmd>Trouble lsp_document_diagnostics<cr>", "Document diagnostics"},
    },

    d = {
        name = "Debug",
        t = {
            "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
            "Toggle Breakpoint",
        },
        d = {
            "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
            "Toggle Breakpoint",
        },
        b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
        s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
        r = { "<cmd>lua require'dap'.continue()<cr>", "Rerun" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        -- n = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        n = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
        p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
        q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        e = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over(End)" },
        o = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
        C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
        D = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
        g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
        R = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
        h = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", "Hover"},
        k = { "<cmd>lua require('dap.ui.variables').hover()<cr>", "Hover"},
    },

    f = {
        name = "Telescope/Find",
        f = {"<cmd>Telescope find_files<cr>", "Find File"},
        F = {"<cmd>Telescope live_grep<cr>", "Live grep"},
        t = {"<cmd>Telescope grep_string<cr>", "Find cursor string"},
        b = {"<cmd>Telescope buffers<cr>", "Find buffers"},
        B = {"<cmd>Telescope file_browser<cr>", "File browser"},
        h = {"<cmd>Telescope help_tags<cr>", "Help tags"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        R = {"<cmd>Telescope registers<cr>", "Registers"},
        c = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        g = {"<cmd>Telescope git_files<cr>", "Git files"},
    },

    g = {
        name = "Git",
        co = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        f = {"<cmd>Telescope git_files<cr>", "Git files"},
        st = {"<cmd>Telescope git_status<cr>", "Git status"},
        cm = {"<cmd>Telescope git_commits<cr>", "Git commits"},
        cbm = {"<cmd>Telescope git_bcommits<cr>", "Git bcommits"},
        p = {'<cmd>lua require"gitsigns".preview_hunk()<CR>', 'Git preview hunk'},
        bl = {'<cmd>lua require"gitsigns".blame_line{full=true}<CR>', 'Git blame line'},
    },

    -- s = {
    --     name = "+Search",
    --     b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
    --     c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
    --     d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
    --     D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
    --     f = {"<cmd>Telescope find_files<cr>", "Find File"},
    --     m = {"<cmd>Telescope marks<cr>", "Marks"},
    --     M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
    --     r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
    --     R = {"<cmd>Telescope registers<cr>", "Registers"},
    --     t = {"<cmd>Telescope live_grep<cr>", "Text"}
    -- },
}

local wk = require("which-key")
wk.register(mappings, opts)

