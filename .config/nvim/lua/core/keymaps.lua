local LspFn = require("plugins.lsp.utils.fn")
-- n, v, i, t = mode names

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M.default = {
  [""] = {
    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down> http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/ empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    { "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true } },
    { "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true } },
    { "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true } },
    { "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true } },
  },

  ["n"] = {
    -- Use control-c instead of escape
    -- { "<C-c>", "<Esc>", { desc = "Esc" } },

    -- Turn of search highlight
    { "<ESC>", "<cmd> noh <CR>", { desc = "no highlight" } },

    -- toogle previous file
    { "<S-Tab>", "<C-^>", { desc = "toggle previous file" } },

    -- switch between windows, this has been overridden by vim-tmux
    -- {"<C-h>", "<C-w>h", {desc="window left"} },
    -- {"<C-l>", "<C-w>l", {desc="window right"} },
    -- {"<C-j>", "<C-w>j", {desc="window down"} },
    -- {"<C-k>", "<C-w>k", {desc="window up"} },
    -- resize windows
    { "<leader>H", ":vertical resize -2<CR>", { desc = "v-resize left" } },
    { "<leader>L>", ":vertical resize +2<CR>", { desc = "v-resize right" } },
    { "<leader>J", ":resize -2<CR>", { desc = "h-resize down" } },
    { "<leader>K", ":resize +2<CR>", { desc = "h-resize up" } },
    -- better split
    { "<leader>-", ":vsplit<CR>", { desc = "v-split" } },
    { "<leader>_", ":split<CR>", { desc = "h-split" } },
    { '<leader>"', ":vsplit<CR>", { desc = "v-split" } },
    { "<leader>%", ":split<CR>", { desc = "h-split" } },
    { '<C-w>"', ":vsplit<CR>", { desc = "v-split" } },
    { "<C-w>%", ":split<CR>", { desc = "h-split" } },

    -- save
    -- { "<C-s>", "<cmd> w <CR>", { desc = "save file" } },

    -- Copy all
    -- {"<C-c>", "<cmd> %y+ <CR>", {desc="copy whole file"} },

    -- jumping
    { "[g", "<C-o>", { desc = "go backward" } },
    { "]g", "<C-i>", { desc = "go forward" } },
    { "<C-u>", "<C-u>zz" },
    { "<C-d>", "<C-d>zz" },
    { "n", "nzzzv" },
    { "N", "Nzzzv" },
    { "*", "*zzzv" },

    -- quicklist movement -- already set in editor/trouble.lua
    -- { "[q", ":cprev<CR>", { desc = "quick list prev" } },
    -- { "]q", ":cnext<CR>", { desc = "quick list next" } },

    -- loclist movement
    { "[l", ":lprev<CR>", { desc = "loclist list prev" } },
    { "]l", ":lnext<CR>", { desc = "loclist list next" } },

    -- line numbers
    { "<leader>n", "<cmd> set nu! <CR>", { desc = "toggle line number" } },
    { "<leader>rn", "<cmd> set rnu! <CR>", { desc = "toggle relative number" } },

    -- new buffer
    -- { "<leader>b", "<cmd> enew <CR>", { desc = "new buffer" } },
  },

  ["i"] = {
    -- go to  beginning and end
    { "<C-a>", "<ESC>^i", { desc = "beginning of line" } },
    { "<C-e>", "<End>", { desc = "end of line" } },
  },

  ["c"] = {
    -- go to  beginning and end
    { "<C-a>", "<Home>", { desc = "beginning of line" } },
    { "<C-e>", "<End>", { desc = "end of line" } },
    -- { "q1", "q!", { desc = "force quit" } },
  },

  ["v"] = {
    -- Don't copy the replaced text after pasting in visual mode
    { "p", '"_dP', { desc = "paste" } },

    -- Block movement
    { "J", ":m '>+1<CR>gv=gv" },
    { "K", ":m '>-2<CR>gv=gv" },

    -- better indenting
    { "<", "<gv", { noremap = true, silent = true } },
    { ">", ">gv", { noremap = true, silent = true } },
  },

  ["x"] = {
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true } },
    -- greatest remap ever
    { "<leader>p", [["_dP]] },

    -- Move selected line / block of text in visual mode
    { "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true } },
    { "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true } },
  },

  ["t"] = {
    { "<ESC><ESC>", termcodes("<C-\\><C-N>"), { desc = "escape terminal mode" } },
    -- {"<esc><esc>", termcodes("<C-\\><C-N>"), {desc="escape terminal mode"} },
    { "<C-w>", termcodes("<C-\\><C-N><C-w>"), { desc = "window command mode" } },
    { "<C-h>", termcodes("<C-\\><C-N><C-w>h"), { desc = "terminal window left" } },
    { "<C-l>", termcodes("<C-\\><C-N><C-w>l"), { desc = "terminal window right" } },
    { "<C-j>", termcodes("<C-\\><C-N><C-w>j"), { desc = "terminal window down" } },
    { "<C-k>", termcodes("<C-\\><C-N><C-w>k"), { desc = "terminal window up" } },
  },

  -- insert and command mode
  [{ "i", "c" }] = {
    -- navigate within insert mode
    { "<C-b>", "<Left>", { desc = "move left" } },
    { "<C-f>", "<Right>", { desc = "move right" } },
    -- { "<C-h>", "<Left>", { desc = "move left" } },
    -- { "<C-l>", "<Right>", { desc = "move right" } },
    -- { "<C-j>", "<Down>", { desc = "move down" } },
    -- { "<C-k>", "<Up>", { desc = "move up" } },
    { "<C-k>", "<C-O>D", { desc = "delete line to end" } },
    { "<C-d>", "<Del>", { desc = "<Del>" } },
    { "<C-h>", "<BS>", { desc = "<BS>" } },
  },

  [{ "n", "v" }] = {
    -- don't yank text on cut ( x )
    -- {"x", '"_x', {desc="cut"} },
    -- don't yank text on delete ( dd )
    -- {"d", '"_d', {desc="delete"} },
  },
}

M.tabufline = {

  ["n"] = {
    -- cycle through buffers
    {
      "<A-}>",
      function()
        require("plugins.ui.tabufline.core").tabuflineNext()
      end,
      { desc = "goto next buffer" },
    },

    {
      "<A-{>",
      function()
        require("plugins.ui.tabufline.core").tabuflinePrev()
      end,
      { desc = "goto prev buffer" },
    },

    -- close buffer + hide terminal buffer
    {
      "<leader>x",
      function()
        require("plugins.ui.tabufline.core").close_buffer()
      end,
      { desc = "close buffer" },
    },
    {
      "<A-x>",
      function()
        require("plugins.ui.tabufline.core").close_buffer()
      end,
      { desc = "close buffer" },
    },
    {
      "<C-w>W",
      function()
        require("plugins.ui.tabufline.core").close_buffer(nil, true)
      end,
      { desc = "close buffer" },
    },
  },
}

M.comment = {

  -- toggle comment in both modes
  [{ "n", "i" }] = {
    {
      "<D-/>",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      { desc = "toggle comment" },
    },
  },

  ["v"] = {
    {
      "<D-/>",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      { desc = "toggle comment" },
    },
    {
      "^[/",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      { desc = "toggle comment" },
    },
  },
}

M.format = {
  ["n"] = {
    {
      "<leader>lf",
      LspFn.format,
      { desc = "lsp formatting" },
    },
  },
}

-- for lsp config non-attach
M.lspconfig = {
  ["n"] = {
    { "<leader>lz", "<cmd>LspInfo<cr>", { desc = "lsp info" } },
  },
}

M.lspconfig_attach = {
  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
  ["n"] = {
    {
      "gd",
      vim.lsp.buf.definition,
      { desc = "[g]oto [d]efinition" },
    },
    {
      "gD",
      vim.lsp.buf.declaration,
      { desc = "[g]oto [D]eclaration" },
    },
    {
      "gi",
      vim.lsp.buf.implementation,
      { desc = "[g]oto [i]mplementation" },
    },
    {
      "gr",
      vim.lsp.buf.references,
      { desc = "[g]oto [r]eferences", nowait = true },
    },
    {
      "gy",
      vim.lsp.buf.type_definition,
      { desc = "[g]oto T[y]pe Definition" },
    },
    { "go", "<cmd>pop<CR>", { desc = "go back" } },

    -- Already setup in nvim.UFO
    -- {"K",
    --   function()
    --     vim.lsp.buf.hover()
    --   end,
    --    {desc="lsp hover"}
    -- },

    {
      "L",
      vim.diagnostic.open_float,
      { desc = "Diagnostic f[L]oat" },
    },

    {
      "S",
      LspFn.signature,
      { desc = "[S]ignature help" },
    },

    {
      "<leader>ra",
      LspFn.renamer,
      { desc = "lsp [r]en[a]me" },
    },

    {
      "<leader>lr",
      LspFn.renamer,
      { desc = "[l]lsp [r]ename" },
    },

    {
      "[d",
      LspFn.diagnostic_goto(false),
      { desc = "goto prev diagnostic" },
    },

    {
      "]d",
      LspFn.diagnostic_goto(true),
      { desc = "goto next diagnostic" },
    },

    {
      "[e",
      LspFn.diagnostic_goto(false, "ERROR"),
      { desc = "goto prev error" },
    },

    {
      "]e",
      LspFn.diagnostic_goto(true, "ERROR"),
      { desc = "goto next error" },
    },

    {
      "[w",
      LspFn.diagnostic_goto(false, "WARN"),
      { desc = "goto prev warning" },
    },

    {
      "]w",
      LspFn.diagnostic_goto(true, "WARN"),
      { desc = "goto next warning" },
    },

    -- {
    --   "<leader>ll",
    --   vim.diagnostic.setloclist,
    --   { desc = "diagnostic setloclist (document)" },
    -- },
    --
    -- {
    --   "<leader>lq",
    --   vim.diagnostic.setqflist,
    --   { desc = "diagnostic setqflist (workspace)" },
    -- },

    {
      "<leader>wa",
      vim.lsp.buf.add_workspace_folder,
      { desc = "add workspace folder" },
    },

    {
      "<leader>wr",
      vim.lsp.buf.remove_workspace_folder,
      { desc = "remove workspace folder" },
    },

    {
      "<leader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      { desc = "list workspace folders" },
    },

    -- L = {"<cmd>Lspsaga show_line_diagnostics<cr>", {desc="Line Diagnostics"}},
    -- p = {"<cmd>Lspsaga preview_definition<cr>", {desc="Preview Definition"}},
    -- r = {"<cmd>Lspsaga rename<cr>", {desc="Rename"}},
    -- x = {"<cmd>cclose<cr>", {desc="Close Quickfix"}},
  },

  ["i"] = {
    {
      "<C-s>",
      LspFn.parameter_hints,
      { desc = "lsp parameter_hints" },
    },
  },

  [{ "n", "v" }] = {
    {
      "<leader>la",
      vim.lsp.buf.code_action,
      { desc = "[l]sp code [a]ction" },
    },

    {
      "<leader>ca",
      vim.lsp.buf.code_action,
      { desc = "lsp [c]ode [a]ction" },
    },
  },
}

M.lazy = {
  -- lazy
  ["n"] = {
    { "<leader>lu", "<cmd>Lazy update<CR>", { desc = "update lazy" } },
  },
}

M.nvimtree = {

  ["n"] = {
    -- toggle
    -- {"<C-n>", "<cmd> NvimTreeToggle <CR>", {desc="toggle nvimtree"} },

    -- focus
    { "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "toggle nvimtree" } },
  },
}

local find_project_files = (function()
  vim.fn.system("git rev-parse --is-inside-work-tree")

  if vim.v.shell_error == 0 then
    return function()
      local builtin = require("telescope.builtin")

      builtin.git_files {}
    end
  else
    return function()
      local builtin = require("telescope.builtin")

      builtin.find_files {}
    end
  end
end)()

M.telescope = {

  ["n"] = {
    -- find
    {
      "<C-p>",
      -- find_project_files,
      function()
        local builtin = require("telescope.builtin")

        builtin.find_files {}
      end,
      { desc = "Files" },
    },
    {
      "<leader>,",
      function()
        local builtin = require("telescope.builtin")

        builtin.buffers {
          sort_mru = true,
          -- ignore_current_buffer = true,
          sort_lastused = true,
        }
      end,
      { desc = "Switch Buffer" },
    },
    {
      "<leader>fb",
      function()
        local builtin = require("telescope.builtin")

        builtin.buffers {
          sort_mru = true,
          ignore_current_buffer = true,
          sort_lastused = true,
        }
      end,
      { desc = "find buffers" },
    },
    {
      "<leader>fp",
      function()
        local builtin = require("telescope.builtin")

        builtin.resume {}
      end,
      { desc = "Resume search" },
    },
    -- {
    --   "<C-\\>",
    --   function()
    --     local builtin = require("telescope.builtin")
    --
    --     builtin.resume {}
    --   end,
    --   { desc = "Resume search" },
    -- },
    {
      "<C-/>",
      function()
        local builtin = require("telescope.builtin")

        builtin.live_grep {}
      end,
      { desc = "Grep" },
    },
    {
      "<C-_>", -- tmux regconize <C-/> with this
      function()
        local builtin = require("telescope.builtin")

        builtin.live_grep {}
      end,
      { desc = "Grep" },
    },
    -- {
    --   "<leader>fs",
    --   function()
    --     local builtin = require("telescope.builtin")
    --
    --     builtin.live_grep {}
    --   end,
    --   { desc = "Grep" },
    -- },
    {
      "<leader>fw",
      function()
        local builtin = require("telescope.builtin")
        local word = vim.fn.expand("<cword>")

        builtin.grep_string { search = word }
      end,
      { desc = "Grep by word" },
    },
    {
      "<leader>ff",
      function()
        local builtin = require("telescope.builtin")

        builtin.find_files {}
      end,
      { desc = "find files" },
    },
    -- {"<leader>ft", "<cmd> Telescope grep_string <CR>", {desc="find cursor string"} },
    {
      "<leader>fa",
      function()
        local builtin = require("telescope.builtin")

        builtin.find_files {
          follow = true,
          no_ignore = true,
          hidden = true,
        }
      end,
      { desc = "find all file" },
    },
    { "<leader>fB", "<cmd> Telescope file_browser <CR>", { desc = "find file browser" } },
    { "<leader>fc", "<cmd> Telescope commands <CR>", { desc = "find commands" } },
    {
      "<leader>p",
      function()
        local builtin = require("telescope.builtin")

        builtin.commands {}
      end,
      { desc = "find commands" },
    },
    {
      "<leader><space>",
      function()
        local builtin = require("telescope.builtin")

        builtin.commands {}
      end,
      { desc = "find commands" },
    },
    { "<leader>;", "<cmd> Telescope command_history <CR>", { desc = "find command history" } },
    { "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "help page" } },
    {
      "<leader>fo",
      function()
        local builtin = require("telescope.builtin")

        builtin.oldfiles { only_cwd = true }
      end,
      { desc = "find oldfiles" },
    },
    {
      "<D-F>",
      function()
        local builtin = require("telescope.builtin")

        builtin.current_buffer_fuzzy_find {}
      end,
      { desc = "Find in current buffer" },
    },
    {
      "<leader>fs",
      function()
        local builtin = require("telescope.builtin")

        builtin.git_status {}
      end,
      { desc = "git status" },
    },
    { "<leader>fm", "<cmd> Telescope marks <CR>", { desc = "find marks" } },
    -- {"<leader>fr", "<cmd> Telescope oldfiles <CR>", {desc="find recent files"} },
    { "<leader>fr", "<cmd> Telescope registers <CR>", { desc = "find registers" } },
    -- {"<leader>fr", "<cmd> Telescope resume <CR>", {desc="resume last search"} },
    { "<leader>fk", "<cmd> Telescope keymaps <CR>", { desc = "show keys" } },
    { "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current buffer" } },

    -- lsp
    { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "search lsp implementation" } },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" } },
    { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" } },

    -- git
    { "<leader>cm", "<cmd> Telescope git_commits <CR>", { desc = "git commits" } },
    { "<leader>gts", "<cmd> Telescope git_status <CR>", { desc = "git status" } },
    {
      "<leader>fg",
      function()
        local builtin = require("telescope.builtin")

        builtin.git_files {}
      end,
      { desc = "git files" },
    },

    -- pick a hidden term
    -- { "<leader>pt", "<cmd> Telescope terms <CR>", { desc = "pick hidden term" } },
    { "<leader>ft", "<cmd> Telescope terms <CR>", { desc = "pick hidden term" } },
  },
}

M.nvterm = {

  ["t"] = {
    -- toggle in terminal mode
    {
      "<D-i>",
      function()
        require("nvterm.terminal").toggle("float")
      end,
      { desc = "Toggle floating term" },
    },
    {
      "<M-i>",
      function()
        require("nvterm.terminal").toggle("float")
      end,
      { desc = "Toggle floating term" },
    },

    {
      "<M-h>",
      function()
        require("nvterm.terminal").toggle("horizontal")
      end,
      { desc = "Toggle horizontal term" },
    },
    -- {"<leader>h",
    --   function()
    --     require("nvterm.terminal").toggle("horizontal")
    --   end,
    --    {desc="Toggle horizontal term"}
    -- },
    -- {"<C-t>",
    --   function()
    --     require("nvterm.terminal").toggle("horizontal")
    --   end,
    --    {desc="Toggle horizontal term"}
    -- },

    {
      "<M-v>",
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      { desc = "Toggle vertical term" },
    },
    {
      "<C-v>",
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      { desc = "Toggle vertical term" },
    },
  },

  ["n"] = {
    -- toggle in normal mode
    {
      "<D-i>",
      function()
        require("nvterm.terminal").toggle("float")
      end,
      { desc = "Toggle floating term" },
    },
    {
      "<M-i>",
      function()
        require("nvterm.terminal").toggle("float")
      end,
      { desc = "Toggle floating term" },
    },

    {
      "<M-h>",
      function()
        require("nvterm.terminal").toggle("horizontal")
      end,
      { desc = "Toggle horizontal term" },
    },
    -- {
    --   "<leader>th",
    --   function()
    --     require("nvterm.terminal").toggle("horizontal")
    --   end,
    --   { desc = "Toggle horizontal term" },
    -- },
    -- {
    --   "<leader>tt",
    --   function()
    --     require("nvterm.terminal").toggle("horizontal")
    --   end,
    --   { desc = "Toggle horizontal term" },
    -- },

    {
      "<M-v>",
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      { desc = "Toggle vertical term" },
    },

    -- {
    --   "<leader>tv",
    --   function()
    --     require("nvterm.terminal").toggle("vertical")
    --   end,
    --   { desc = "Toggle vertical term" },
    -- },
  },
}

M.whichkey = {

  ["n"] = {
    {
      "<leader>wK",
      function()
        vim.cmd("WhichKey")
      end,
      { desc = "which-key all keymaps" },
    },
    {
      "<leader>wk",
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      { desc = "which-key query lookup" },
    },
  },
}

M.blankline = {

  ["n"] = {
    {
      "<leader>cc",
      function()
        local config = { scope = {} }
        config.scope.exclude = { language = {}, node_type = {} }
        config.scope.include = { node_type = {} }
        local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

        if node then
          local start_row, _, end_row, _ = node:range()
          if start_row ~= end_row then
            vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
            vim.api.nvim_feedkeys("_", "n", true)
          end
        end
      end,
      { desc = "Blankline Jump to current context" },
    },
  },
}

M.git = {

  ["n"] = {
    -- Navigation through hunks
    {
      "]h",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      { desc = "Next hunk" },
    },
    {
      "[h",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      { desc = "Prev hunk" },
    },
    {
      "[H",
      function()
        require("gitsigns").nav_hunk("first")
      end,
      { desc = "First hunk" },
    },
    {
      "]H",
      function()
        require("gitsigns").nav_hunk("last")
      end,
      { desc = "Last hunk" },
    },

    -- Actions
    {
      "<leader>ghr",
      function()
        require("gitsigns").reset_hunk()
      end,
      { desc = "Reset hunk" },
    },

    {
      "<leader>ghs",
      function()
        require("gitsigns").stage_hunk()
      end,
      { desc = "stage hunk" },
    },

    {
      "<leader>ghu",
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      { desc = "undo stage hunk" },
    },

    {
      "<leader>ghS",
      function()
        require("gitsigns").stage_buffer()
      end,
      { desc = "stage buffer" },
    },

    {
      "<leader>ghR",
      function()
        require("gitsigns").reset_buffer()
      end,
      { desc = "Reset buffer" },
    },

    {
      "<leader>ghp",
      function()
        require("gitsigns").preview_hunk()
      end,
      { desc = "Preview hunk" },
    },

    {
      "H",
      function()
        require("gitsigns").preview_hunk()
      end,
      { desc = "Preview hunk" },
    },

    {
      "<leader>ghd",
      function()
        require("gitsigns").diffthis()
      end,
      { desc = "diff hunk" },
    },

    {
      "<leader>ghD",
      function()
        require("gitsigns").diffthis("~")
      end,
      { desc = "diff hunk" },
    },

    {
      "<leader>ghb",
      function()
        require("gitsigns").blame_line()
      end,
      { desc = "Blame line" },
    },

    {
      "<leader>gtb",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      { desc = "Toggle current line blame" },
    },

    {
      "<leader>gtd",
      function()
        require("gitsigns").toggle_deleted()
      end,
      { desc = "Toggle deleted" },
    },
  },
}

M.dap = {

  ["n"] = {
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      { desc = "Breakpoint Condition" },
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      { desc = "Toggle Breakpoint" },
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      { desc = "Continue" },
    },
    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end,  {desc="Run with Args"} },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      { desc = "Run to Cursor" },
    },
    {
      "<leader>dg",
      function()
        require("dap").goto_()
      end,
      { desc = "Go to line (no execute)" },
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      { desc = "Step Into" },
    },
    {
      "<leader>dj",
      function()
        require("dap").down()
      end,
      { desc = "Down" },
    },
    {
      "<leader>dk",
      function()
        require("dap").up()
      end,
      { desc = "Up" },
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      { desc = "Run Last" },
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      { desc = "Step Out" },
    },
    {
      "<leader>dO",
      function()
        require("dap").step_over()
      end,
      { desc = "Step Over" },
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      { desc = "Pause" },
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      { desc = "Toggle REPL" },
    },
    {
      "<leader>ds",
      function()
        require("dap").session()
      end,
      { desc = "Session" },
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      { desc = "Terminate" },
    },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      { desc = "Widgets" },
    },
    -- {"<leader>dt",
    --    "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
    --    {desc="Toggle Breakpoint"}
    -- },
    -- {"<leader>dd",
    --    "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
    --    {desc="Toggle Breakpoint"}
    -- },
    -- {"<leader>db", "<cmd>lua require'dap'.step_back()<cr>", {desc="Step Back"} },
    -- {"<leader>ds", "<cmd>lua require'dap'.continue()<cr>", {desc="Start"} },
    -- {"<leader>dr", "<cmd>lua require'dap'.continue()<cr>", {desc="Rerun"} },
    -- {"<leader>dc", "<cmd>lua require'dap'.continue()<cr>", {desc="Continue"} },
    -- -- {"<leader>dn", "<cmd>lua require'dap'.continue()<cr>", {desc="Continue"} },
    -- {"<leader>dn", "<cmd>lua require'dap'.run_to_cursor()<cr>", {desc="Run To Cursor"} },
    -- {"<leader>dp", "<cmd>lua require'dap'.pause.toggle()<cr>", {desc="Pause"} },
    -- {"<leader>dq", "<cmd>lua require'dap'.close()<cr>", {desc="Quit"} },
    -- {"<leader>di", "<cmd>lua require'dap'.step_into()<cr>", {desc="Step Into"} },
    -- {"<leader>de", "<cmd>lua require'dap'.step_over()<cr>", {desc="Step Over(End)"} },
    -- {"<leader>do", "<cmd>lua require'dap'.step_out()<cr>", {desc="Step Out"} },
    -- {"<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", {desc="Run To Cursor"} },
    -- {"<leader>dD", "<cmd>lua require'dap'.disconnect()<cr>", {desc="Disconnect"} },
    -- {"<leader>dg", "<cmd>lua require'dap'.session()<cr>", {desc="Get Session"} },
    -- {"<leader>dR", "<cmd>lua require'dap'.repl.toggle()<cr>", {desc="Toggle Repl"} },
    -- {"<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", {desc="Hover"} },
    -- {"<leader>dk", "<cmd>lua require('dap.ui.variables').hover()<cr>", {desc="Hover"} },
    -- {"<leader>du", "<cmd>lua require('dapui').toggle()<cr>", {desc="Toggle UI"} },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      { desc = "Toggle UI" },
    },
  },

  [{ "n", "v" }] = {
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      { desc = "Eval" },
    },
  },
}

M.illuminate = {
  ["n"] = {
    {
      "]]",
      function()
        require("illuminate")["goto_next_reference"](false)
      end,
      { desc = "Next reference" },
    },
    {
      "[[",
      function()
        require("illuminate")["goto_prev_reference"](false)
      end,
      { desc = "Prev reference" },
    },
  },
}

M.harpoon = function()
  local keys = {
    ["n"] = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        { desc = "Harpoon File" },
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        { desc = "Harpoon Quick Menu" },
      },
    },
  }

  for i = 1, 5 do
    table.insert(keys["n"], {
      "<leader>" .. i,
      function()
        require("harpoon"):list():select(i)
      end,
      desc = "Harpoon to File " .. i,
    })
  end

  return keys
end

return M
