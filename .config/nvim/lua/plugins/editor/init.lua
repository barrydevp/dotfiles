return {
  -- key mapping
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    init = function()
      require("core.utils").load_mappings("whichkey")
    end,
    opts = {
      plugins = { spelling = true },
    },
  },

  -- tmux stuff
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- terminal
  {
    "barrydevp/nvterm",
    init = function()
      require("core.utils").load_mappings("nvterm")
    end,
    config = function(_, opts)
      require("nvterm").setup(opts)
    end,
  },

  -- winbar for showing code context in status bar
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --   -- lazy = false,
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     "nvim-telescope/telescope-fzf-native.nvim",
  --   },
  --   opts = function()
  --     local utils = require("dropbar.utils")
  --
  --     return {
  --       bar = {
  --         hover = false,
  --         sources = function(buf, _)
  --           local sources = require("dropbar.sources")
  --           if vim.bo[buf].ft == "markdown" then
  --             return {
  --               -- sources.path,
  --               sources.markdown,
  --             }
  --           end
  --           if vim.bo[buf].buftype == "terminal" then
  --             return {
  --               sources.terminal,
  --             }
  --           end
  --           return {
  --             -- sources.path,
  --             utils.source.fallback {
  --               sources.lsp,
  --               sources.treesitter,
  --             },
  --           }
  --         end,
  --       },
  --     }
  --   end,
  -- },

  -- discord rich presence
  -- use "andweeb/presence.nvim"

  -- highlights characters to navigate
  -- {
  --   "unblevable/quick-scope",
  --   -- event = "BufRead",
  --   event = "VeryLazy",
  --   init = function()
  --     -- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
  --     vim.cmd([[ source ~/.config/nvim/configs/quickscope.vim ]])
  --   end,
  -- },

  -- quick list
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      "junegunn/fzf",
    },
    opts = {
      func_map = {
        drop = "o",
        openc = "O",
        split = '"',
        vsplit = "%",
        -- tabdrop = "<C-t>",
        -- -- set to empty string to disable
        -- tabc = "",
        -- ptogglemode = "z,",
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    ft = { "gitcommit", "diff" },
    dependencies = {
      "tpope/vim-fugitive",
      cmd = { "G", "Git" },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        require("core.utils").load_mappings("git", { buffer = bufnr })
      end,
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      require("core.utils").load_mappings("illuminate")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          require("core.utils").load_mappings("illuminate", { buffer = buffer })
        end,
      })
    end,
  },
}
