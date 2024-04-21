local api = require("nvim-tree.api")
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
    openfile.fn("preview", filename)
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
  local node = api.tree.get_node_under_cursor()
  local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
  local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
  if node.name == ".." and TreeExplorer ~= nil then
    basedir = TreeExplorer.cwd
  end
  opts = opts or {}
  opts.cwd = basedir
  opts.search_dirs = { basedir }
  opts.attach_mappings = view_selection
  return require("telescope.builtin")[func_name](opts)
end

function M.on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<leader>ff", M.launch_find_files, opts("Launch Find Files"))
  vim.keymap.set("n", "<C-p>", M.launch_find_files, opts("Launch Find Files"))
  vim.keymap.set("n", "<C-_>", function()
    M.launch_telescope("live_grep")
  end, opts("Live grep"))
  vim.keymap.set("n", "<C-/>", function()
    M.launch_telescope("live_grep")
  end, opts("Live grep"))
  -- vim.keymap.set("n", "<C-\\>", function()
  --   M.launch_telescope("live_grep")
  -- end, opts("Live grep"))
  vim.keymap.set("n", "<leader>fF", function()
    M.launch_telescope("live_grep")
  end, opts("Live grep"))
  vim.keymap.set("n", "<leader>fs", function()
    M.launch_telescope("live_grep")
  end, opts("Live grep"))
  vim.keymap.set("n", "<leader>fw", function()
    local word = vim.fn.expand("<cword>")

    M.launch_telescope("grep_string", { search = word })
  end, opts("Grep by word"))

  -- Git stuff
  vim.keymap.set("n", "[h", api.node.navigate.git.prev, opts("Prev Git"))
  vim.keymap.set("n", "]h", api.node.navigate.git.next, opts("Next Git"))

  -- Directory
  vim.keymap.set("n", "gd", api.tree.change_root_to_node, opts("cd"))
  vim.keymap.set("n", "go", api.tree.change_root_to_parent, opts("cd .."))

  -- File
  vim.keymap.set("n", '"', api.node.open.vertical, opts("Open vertical"))
  vim.keymap.set("n", "%", api.node.open.horizontal, opts("Open horizontal"))
end

return M
