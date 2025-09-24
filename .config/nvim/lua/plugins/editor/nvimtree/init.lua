return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "toggle nvimtree" } },
    },
    opts = function()
      vim.g.nvimtree_side = "left"

      return {
        on_attach = require("utils").lsp.on_attach,
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = true,
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
          side = vim.g.nvimtree_side,
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
          highlight_git = true,
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
    end,
  },
}
