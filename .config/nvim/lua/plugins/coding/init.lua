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

}
