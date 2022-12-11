local present, nvimtree = pcall(require, "nvim-tree")

if not present then
  return
end

local lib = require("nvim-tree.lib")
local openfile = require("nvim-tree.actions.node.open-file")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local M = {}

local view_selection = function(prompt_bufnr, map)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local filename = selection.filename
    if filename == nil then
      filename = selection[1]
    end
    openfile.fn("edit", filename)
  end)
  return true
end

function M.launch_live_grep(opts)
  return M.launch_telescope("live_grep", opts)
end

function M.launch_find_files(opts)
  return M.launch_telescope("find_files", opts)
end

function M.launch_telescope(func_name, opts)
  local telescope_status_ok, _ = pcall(require, "telescope")
  if not telescope_status_ok then
    return
  end
  local node = lib.get_node_at_cursor()
  local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
  local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
  if node.name == ".." and TreeExplorer ~= nil then
    basedir = TreeExplorer.cwd
  end
  opts = opts or {}
  opts.cwd = basedir
  opts.search_dirs = { basedir }
  opts.attach_mappings = view_selection
  opts.no_ignore = true
  opts.no_ignore_parent = true
  return require("telescope.builtin")[func_name](opts)
end

local function custom_callback(callback_name)
  return string.format(":lua require('plugins.configs.nvimtree').%s()<CR>", callback_name)
end

local options = {
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
  },
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    timeout = 400,
  },
  filters = {
    custom = {
      "^\\.git/",
    },
    dotfiles = false,
  },
  view = {
    adaptive_size = true,
    side = "left",
    width = 32,
    mappings = {
      list = {
        { key = "<leader>ff", cb = custom_callback("launch_find_files") },
        { key = "<leader>fF", cb = custom_callback("launch_live_grep") },
      },
    },
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    -- highlight_git = false,
    -- highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
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

vim.g.nvimtree_side = options.view.side
nvimtree.setup(options)

return M
