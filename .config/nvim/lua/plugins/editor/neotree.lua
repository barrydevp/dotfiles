local function get_dir_path(node)
  local path = node:get_id()
  if node.type == "file" then
    path = node:get_parent_id()
  end
  return path
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute { toggle = true }
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() }
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute { source = "git_status", toggle = true }
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute { source = "buffers", toggle = true }
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["<C-p>"] = "fzf_find",
            ["<leader>ff"] = "fzf_find",
            ["<C-f>"] = "fzf_grep",
            ["<leader>sg"] = "fzf_grep",
          },
        },
      },
      window = {
        auto_expand_width = false,
        width = 35,
        mappings = {
          ["<space>"] = "none",
          ["c"] = "copy_to_clipboard",
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",
          ["y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["[h"] = "prev_git_modified",
          ["]h"] = "next_git_modified",
          ["o"] = "open",
          ["O"] = {
            "show_help",
            nowait = false,
            config = { title = "Order by", prefix_key = "O" },
          },
          ["oc"] = false,
          ["od"] = false,
          ["og"] = false,
          ["om"] = false,
          ["on"] = false,
          ["os"] = false,
          ["ot"] = false,
          ["OC"] = { "order_by_created", nowait = false },
          ["OD"] = { "order_by_diagnostics", nowait = false },
          ["OG"] = { "order_by_git_status", nowait = false },
          ["OM"] = { "order_by_modified", nowait = false },
          ["ON"] = { "order_by_name", nowait = false },
          ["OS"] = { "order_by_size", nowait = false },
          ["OT"] = { "order_by_type", nowait = false },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
      commands = {
        fzf_find = function(state)
          local node = state.tree:get_node()
          require("fzf-lua").files { cwd = get_dir_path(node) }
        end,
        fzf_grep = function(state)
          local node = state.tree:get_node()
          require("fzf-lua").live_grep { cwd = get_dir_path(node) }
        end,
      },
    },
    config = function(_, opts)
      -- LSP rename support from Snacks
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      -- setup here
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}
