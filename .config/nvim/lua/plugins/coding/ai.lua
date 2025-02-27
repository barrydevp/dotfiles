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

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = false,
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4",
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "stevearc/dressing.nvim",
        opts = {
          input = {
            enabled = false,
          },
        },
      },
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      -- add any opts here
      -- for example
      provider = "copilot",
    },
  },
}
