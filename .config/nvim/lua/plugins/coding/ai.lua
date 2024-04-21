local config = require("core.config")

return {
  {
    "codota/tabnine-nvim",
    -- dir = "/Users/apple/Dev/github.com/barrydevp/tabnine-nvim",
    build = "./dl_binaries.sh",
    lazy = false,
    cond = config.coding.ai == "tabnine",
    opts = {
      disable_auto_comment = false, -- already have an autocmd for this
      accept_keymap = "<A-]>",
      dismiss_keymap = "<C-]>",
      debounce_ms = 150,
      suggestion_color = { gui = "#808080", cterm = 244 },
      exclude_filetypes = { "TelescopePrompt", "NvimTree", "terminal" },
      log_file_path = nil, -- absolute path to Tabnine log file
      codelens_enabled = false,
    },
  },

  {
    "github/copilot.vim",
    event = "InsertEnter",
    cond = config.coding.ai == "copilotvim",
    init = function()
      vim.g.copilot_no_tab_map = true

      vim.keymap.set("i", "<C-l>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-previous)")
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = config.coding.ai == "copilot",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 150,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          -- next = "<M-]>",
          -- prev = "<M-[>",
          next = "<C-l>",
          prev = "<C-j>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- load highlights
      vim.api.nvim_command("highlight link CopilotAnnotation AIAnnotation")
      vim.api.nvim_command("highlight link CopilotSuggestion AISuggestion")
    end,
  },

  {
    "sourcegraph/sg.nvim",
    lazy = false,
    cond = false,
    dependencies = {
      "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
    },
    -- If you have a recent version of lazy.nvim, you don't need to add this!
    build = "nvim -l build/init.lua",
    opts = {
      enable_cody = false,
    },
  },
}
