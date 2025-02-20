local config = require("core.config")
local rootutils = require("utils.root")
local M = {}

M.set_keymaps = function(mappings, opts)
  for mode, mapping in pairs(mappings) do
    for _, args in ipairs(mapping) do
      -- [1] lhs, [2] rhs, [3] opts
      vim.keymap.set(mode, args[1], args[2], vim.tbl_extend("force", opts or {}, args[3] or {}))
    end
  end
end

---@param buf number?
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

---@param opts WantsOpts
---@return boolean
function M.wants(opts)
  if opts.ft then
    opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
    for _, f in ipairs(opts.ft) do
      if vim.bo[M.buf].filetype == f then
        return true
      end
    end
  end
  if opts.root then
    opts.root = type(opts.root) == "string" and { opts.root } or opts.root
    return rootutils.detectors.pattern(M.buf, opts.root) > 0
  end
  return false
end

return M
