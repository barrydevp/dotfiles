local on_attach = function(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  local treeutils = require("plugins.configs.treeutils")
  vim.keymap.set("n", "<leader>ff", treeutils.launch_find_files, opts("Launch Find Files"))
  vim.keymap.set("n", "<C-p>", treeutils.launch_find_files, opts("Launch Find Files"))
  vim.keymap.set("n", "<leader>fF", treeutils.launch_live_grep, opts("Launch Live Grep"))
  vim.keymap.set("n", "<leader>fw", treeutils.launch_live_grep, opts("Launch Live Grep"))
  vim.keymap.set("n", "[h", api.node.navigate.git.prev, opts("Prev Git"))
  vim.keymap.set("n", "]h", api.node.navigate.git.next, opts("Next Git"))

  --
end

local options = {
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filters = {
    custom = {
      "^\\.git/",
    },
    dotfiles = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    timeout = 400,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    root_folder_label = false,
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      glyphs = {
        default = "",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

return options
