return {
  -- comment
  {
    "numToStr/Comment.nvim",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
          enable_autocmd = false,
        },
      },
    },
    keys = {
      { "gcc", mode = "n" },
      { "gc", mode = "v" },
      { "gbc", mode = "n" },
      { "gb", mode = "v" },
    },
    init = function()
      require("core.utils").load_mappings("comment")
    end,
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  -- editorconfig
  {
    "editorconfig/editorconfig-vim",
    lazy = false,
  },

  -- auto detect indent
  {
    "tpope/vim-sleuth",
    event = "BufWinEnter",
  },

  -- matchup
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      -- may set any options here TODO
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- improve native vim repeat "."
  {
    "tpope/vim-repeat",
    event = "InsertEnter",
  },

  -- surround
  {
    "echasnovski/mini.surround",
    event = "BufReadPost",
    config = function()
      require("mini.surround").setup()
    end,
  },

  -- repeat action
  -- {
  --   "tpope/vim-repeat",
  --   event = "InsertEnter",
  -- },

  -- obsidian note taking
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    otps = {
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "personal",
          path = vim.fn.expand("$OBSIDIAN_VAULT_PATH"),
        },
      },

      -- -- see below for full list of options 👇
      -- notes_subdir = "notes",
      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },
    },
  },
}
