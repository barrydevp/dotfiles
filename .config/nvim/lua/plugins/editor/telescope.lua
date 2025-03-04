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

return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
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
        "<C-f>",
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
      -- { "<leader>ft", "<cmd> Telescope terms <CR>", { desc = "pick hidden term" } },
    },
    opts = function()
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        builtin.find_files { no_ignore = true, default_text = line }
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        builtin.find_files { hidden = true, default_text = line }
      end

      local function find_command()
        if 1 == vim.fn.executable("rg") then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable("where") then
          return { "where", "/r", ".", "*" }
        end
      end

      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          -- selection_caret = " ",
          entry_prefix = "  ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            height = 0.80,
            width = 0.80,
            preview_cutoff = 120,
            horizontal = { preview_width = 0.55, results_width = 0.8 },
            vertical = { width = 0.55, height = 0.8, preview_cutoff = 0 },
            prompt_position = "top",
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules", ".git/", "zig%-cache" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          -- -- Developer configurations: Not meant for general override
          -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<C-t>"] = open_with_trouble,
              ["<C-i>"] = find_files_no_ignore,
              ["<C-h>"] = find_files_with_hidden,
              ["<C-s>"] = actions.cycle_history_next,
              ["<C-r>"] = actions.cycle_history_prev,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-tab>"] = actions.drop_all,
              ["<esc>"] = actions.close,
              ["<C-c>"] = false,
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
            n = {
              ["q"] = actions.close,
              ["p"] = actions.toggle_selection + actions.move_selection_next,
              ["P"] = actions.drop_all,
            },
          },
        },

        pickers = {
          find_files = {
            find_command = find_command,
            hidden = true,
          },
        },

        extensions_list = { "terms", "fzf" },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
}
