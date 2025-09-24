local Utils = require("utils")

return {
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
      { desc = "[g]oto [r]eferences" },
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
      Utils.lsp.open_line_diagnostics,
      { desc = "Diagnostic f[L]oat" },
    },

    {
      "S",
      Utils.lsp.signature,
      { desc = "[S]ignature help" },
    },

    {
      "<leader>ra",
      Utils.lsp.renamer,
      { desc = "lsp [r]en[a]me", expr = true },
    },

    {
      "<leader>lr",
      Utils.lsp.renamer,
      { desc = "[l]lsp [r]ename", expr = true },
    },

    {
      "[d",
      Utils.lsp.diagnostic_goto(false),
      { desc = "goto prev diagnostic" },
    },

    {
      "]d",
      Utils.lsp.diagnostic_goto(true),
      { desc = "goto next diagnostic" },
    },

    {
      "[e",
      Utils.lsp.diagnostic_goto(false, "ERROR"),
      { desc = "goto prev error" },
    },

    {
      "]e",
      Utils.lsp.diagnostic_goto(true, "ERROR"),
      { desc = "goto next error" },
    },

    {
      "[w",
      Utils.lsp.diagnostic_goto(false, "WARN"),
      { desc = "goto prev warning" },
    },

    {
      "]w",
      Utils.lsp.diagnostic_goto(true, "WARN"),
      { desc = "goto next warning" },
    },

    {
      "]]",
      function()
        Utils.lsp.jump_reference(true)
      end,
      desc = "Next Reference",
    },
    {
      "[[",
      function()
        Utils.lsp.jump_reference(false)
      end,
      desc = "Prev Reference",
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
      Utils.lsp.parameter_hints,
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
