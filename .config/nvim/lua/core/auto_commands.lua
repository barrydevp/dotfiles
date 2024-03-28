local api = vim.api
local autocmd = api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = {
    "qf",
    "packer",
    "fugitive",
    "NvimTree",
    "Trouble",
    "spectre_panel",
  },
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- auto close some filetype with <q>
autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "nofile",
    "lspinfo",
    "terminal",
    "prompt",
    "toggleterm",
    "fugitive",
    "copilot",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    api.nvim_buf_set_keymap(event.buf, "n", "q", "<CMD>close<CR>", { silent = true })
  end,
})

-- disable auto comment on the next line
autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- if vim.bo.filetype == "javascript" then
    --   return
    -- end

    vim.opt_local.formatoptions:remove { "r", "o", "c" }
    -- do the rest of the callback
  end,
  -- command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

-- disable some keymap on the CmdWin (q:)
autocmd("CmdwinEnter", {
  pattern = "[:>]",
  callback = function()
    api.nvim_buf_del_keymap(0, "n", "<CR>")
    api.nvim_buf_del_keymap(0, "x", "<CR>")
    -- api.nvim_buf_del_keymap(0, "n", "<C-C>")
    -- local nmaps = api.nvim_buf_get_keymap(0, "n")
    --
    -- for _, map in pairs(nmaps) do
    --     api.nvim_buf_del_keymap(0, "n", map.lhs)
    --   -- if map.lhs == "<CR>" or map.lhs == "<C-c>" then
    --     api.nvim_buf_del_keymap(0, "n", map.lhs)
    --   -- end
    -- end
  end,
})

-- config file
autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})
