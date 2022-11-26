-- n, v, i, t = mode names

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M._core = {
  _ = {
    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
  },

  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
  },

  n = {
    ["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "window left" },
    ["<C-l>"] = { "<C-w>l", "window right" },
    ["<C-j>"] = { "<C-w>j", "window down" },
    ["<C-k>"] = { "<C-w>k", "window up" },
    -- resize windows
    ["<M-h>"] = { ":vertical resize -2<CR>", "v-resize left" },
    ["<M-l>"] = { ":vertical resize +2<CR>", "v-resize right" },
    ["<M-j>"] = { ":resize -2<CR>", "h-resize down" },
    ["<M-k>"] = { ":resize +2<CR>", "h-resize up" },
    -- better split
    -- ['<leader>h']= {':ls<cr> :vertical sb '},
    ["<leader>-"] = { ":vsplit<CR>", "v-split" },
    ["<leader>_"] = { ":split<CR>", "h-split" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- jumping
    ["g["] = { "<C-o>", "go backward" },
    ["g]"] = { "<C-i>", "go forward" },

    -- quicklist movement
    ["[q"] = { ":cprev<CR>", "quick list prev" },
    ["]q"] = { ":cnext<CR>", "quick list next" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -- new buffer
    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },
  },

  t = { ["<C-x>"] = { termcodes("<C-\\><C-N>"), "escape terminal mode" } },

  v = {
    -- Don't copy the replaced text after pasting in visual mode
    ["p"] = { '"_dP', "paste" },

    -- Block movement
    ["J"] = { ":m '>+1<CR>gv=gv" },
    ["K"] = { ":m '>-2<CR>gv=gv" },

    -- better indenting
    ["<"] = { "<gv", opts = { noremap = true, silent = true } },
    [">"] = { ">gv", opts = { noremap = true, silent = true } },
  },

  x = {
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },

    -- Move selected line / block of text in visual mode
    ["K"] = { ":move '<-2<CR>gv-gv", opts = { noremap = true, silent = true } },
    ["J"] = { ":move '>+1<CR>gv-gv", opts = { noremap = true, silent = true } },
  },

  nv = {
    -- don't yank text on cut ( x )
    ["x"] = { '"_x', "cut" },
    -- don't yank text on delete ( dd )
    ["d"] = { '"_d', "delete" },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<C-t>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },

    ["T"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },

    -- pick buffers via numbers
    ["<Bslash>"] = { "<cmd> TbufPick <CR>", "Pick buffer" },

    -- close buffer + hide terminal buffer
    ["<leader>x"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "close buffer",
    },
  },
}

M.bufferline = {
  plugin = true,

  n = {
    -- map("n", m.close_buffer, ":bdelete<CR>")
    -- map("n", "<leader>x", ":lua require('bufdelete').bufdelete(0, true)<CR>")
    -- close  buffer
    ["<leader>x"] = {
      function()
        require("utils").close_buffer()
      end,
      "close buffer",
    },
    ["<C-t>"] = { ":BufferLineCycleNext <CR>", "next buf" },
    ["T"] = { ":BufferLineCyclePrev <CR>", "prev buf" },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
  n = {
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "lsp declaration",
    },

    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "lsp definition",
    },

    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },

    ["L"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "lsp hover",
    },

    ["gk"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },

    ["go"] = {
      "<cmd>pop<CR>",
      "go back",
    },

    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },

    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },

    ["<leader>ra"] = {
      function()
        require("nvchad_ui.renamer").open()
      end,
      "lsp rename",
    },

    ["<leader>lr"] = {
      function()
        vim.lsp.buf.rename()
      end,
      "lsp rename",
    },

    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },

    ["gr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "lsp references",
    },

    ["<leader>lo"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },

    ["d]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },

    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "diagnostic setloclist",
    },

    ["<leader>lf"] = {
      function()
        -- vim.lsp.buf.format { async = true }
        require("plugins.lsp.core").lsp_formatting()
      end,
      "lsp formatting",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },

    ["<leader>lz"] = {
      "<cmd>LspInfo<cr>",
      "lsp info",
    },
    -- L = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
    -- p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
    ["<leader>lq"] = {
      "<cmd>Trouble quickfix<cr>",
      "Quickfix",
    },
    -- r = {"<cmd>Lspsaga rename<cr>", "Rename"},
    -- x = {"<cmd>cclose<cr>", "Close Quickfix"},

    ["<leader>lt"] = {
      "<cmd>Trouble<cr>",
      "Show Diagnostics(Troubel)",
    },

    ["<leader>liw"] = {
      "<cmd>Trouble workspace_diagnostics<cr>",
      "Workspace diagnostics",
    },

    ["<leader>lid"] = {
      "<cmd>Trouble document_diagnostics<cr>",
      "Document diagnostics",
    },
  },

  v = {
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.range_code_action()
      end,
      "lsp code_action",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    -- ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

    -- focus
    -- ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fF"] = { "<cmd> Telescope live_grep<cr>", "live grep" },
    ["<leader>ft"] = { "<cmd> Telescope grep_string <CR>", "find cursor string" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fB"] = { "<cmd> Telescope file_browser <CR>", "find file browser" },
    ["<leader>fc"] = { "<cmd> Telescope commands <CR>", "find commands" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "find marks" },
    ["<leader>fr"] = { "<cmd> Telescope oldfiles <CR>", "find recent files" },
    ["<leader>fR"] = { "<cmd> Telescope registers <CR>", "find registers" },
    ["<leader>fs"] = { "<cmd> Telescope resume <CR>", "resume last search" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },

    -- lsp
    ["<leader>fi"] = { "<cmd>Telescope lsp_implementations<cr>", "search lsp implementation" },
    ["<leader>lS"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    -- ["<leader>lS"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },
    ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "git files" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle("float")
      end,
      "toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle("horizontal")
      end,
      "toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      "toggle vertical term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle("float")
      end,
      "toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle("horizontal")
      end,
      "toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      "toggle vertical term",
    },

    -- new

    ["<leader>h"] = {
      function()
        require("nvterm.terminal").new("horizontal")
      end,
      "new horizontal term",
    },

    ["<leader>v"] = {
      function()
        require("nvterm.terminal").new("vertical")
      end,
      "new vertical term",
    },
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd("WhichKey")
      end,
      "which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      "which-key query lookup",
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd([[normal! _]])
        end
      end,

      "Jump to current_context",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    ["gv"] = {
      "<cmd>GV<CR>",
      "commit all",
    },

    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>hr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>hs"] = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "stage buffer",
    },

    ["<leader>hu"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "undo stage hunk",
    },

    ["<leader>hp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>hd"] = {
      function()
        require("gitsigns").diffthis("~")
      end,
      "undo stage hunk",
    },

    ["<leader>hb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>tb"] = {
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      "Toggle current line blame",
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

M.dap = {
  plugin = true,

  n = {
    ["<leader>dt"] = {
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
      "Toggle Breakpoint",
    },
    ["<leader>dd"] = {
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
      "Toggle Breakpoint",
    },
    ["<leader>db"] = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    ["<leader>ds"] = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    ["<leader>dr"] = { "<cmd>lua require'dap'.continue()<cr>", "Rerun" },
    ["<leader>dc"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    -- ["<leader>dn"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    ["<leader>dn"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    ["<leader>dp"] = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
    ["<leader>dq"] = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    ["<leader>di"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    ["<leader>de"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over(End)" },
    ["<leader>do"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    ["<leader>dC"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    ["<leader>dD"] = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    ["<leader>dg"] = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    ["<leader>dR"] = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    ["<leader>du"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    ["<leader>dh"] = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", "Hover" },
    ["<leader>dk"] = { "<cmd>lua require('dap.ui.variables').hover()<cr>", "Hover" },
  },
}

return M
