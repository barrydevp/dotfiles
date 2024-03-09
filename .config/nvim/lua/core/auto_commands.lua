local autocmd = vim.api.nvim_create_autocmd

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
    vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<CMD>close<CR>", { silent = true })
  end,
})

-- disable auto comment on the next line
autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})
