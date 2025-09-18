return {
  -- comments
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- {
  --   "numToStr/Comment.nvim",
  --   dependencies = {
  --     {
  --       "JoosepAlviste/nvim-ts-context-commentstring",
  --       opts = {
  --         enable_autocmd = false,
  --       },
  --     },
  --   },
  --   keys = {
  --     { "gcc", mode = "n" },
  --     { "gc", mode = "v" },
  --     { "gbc", mode = "n" },
  --     { "gb", mode = "v" },
  --   },
  --   init = function()
  --     require("utils").load_keymaps("comment")
  --   end,
  --   opts = function()
  --     return {
  --       pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  --     }
  --   end,
  -- },

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
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "s",
        visual_line = "gs",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
  },

  --
  {
    "nvim-mini/mini.ai",
    version = "*",
    event = "VeryLazy",
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      require("mini.ai").setup {
        custom_textobjects = {
          f = spec_treesitter {
            a = "@function.outer",
            i = "@function.inner",
          },
          c = spec_treesitter {
            a = "@class.outer",
            i = "@class.inner",
          },
          b = spec_treesitter {
            a = "@block.outer",
            i = "@block.inner",
          },
        },
      }
    end,
  },
}
