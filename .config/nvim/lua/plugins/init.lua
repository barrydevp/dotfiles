-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {
  "nvim-lua/plenary.nvim",

  {
    "barrydevp/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "barrydevp/ui.nvim",
    branch = "v2.0",
    lazy = false,
    init = function()
      require("core.utils").load_mappings("tabufline")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "tbline")

      require("nvchad_ui")
    end,
  },

  -- color, icons related stuff
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require("nvchad_ui.icons").devicons }
    end,
    config = function()
      dofile(vim.g.base46_cache .. "devicons")
      require("plugins.configs.webdevicons")
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      require("core.utils").lazy_load("nvim-colorizer.lua")
    end,
    config = function()
      require("plugins.configs.colorizer")
    end,
  },

  -- indent decorator
  {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    init = function()
      require("core.utils").lazy_load("indent-blankline.nvim")
      require("core.utils").load_mappings("blankline")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "blankline")
      require("plugins.configs.blankline")
    end,
  },

  -- syntax analyzer and parser
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load("nvim-treesitter")
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      dofile(vim.g.base46_cache .. "syntax")
      require("plugins.configs.treesitter")
    end,
  },
  -- requires = {
  --   -- 	-- "windwp/nvim-ts-autotag",
  --   { "JoosepAlviste/nvim-ts-context-commentstring" },
  --   -- { "jose-elias-alvarez/typescript.nvim" },
  --   -- 	-- { "Hoffs/omnisharp-extended-lsp.nvim" },
  --   -- 	-- {
  --   -- 	--     "nvim-treesitter/playground",
  --   -- 	--     cmd = "TSHighlightCapturesUnderCursor",
  --   -- 	-- },
  --   { "nvim-treesitter/nvim-treesitter-textobjects" },
  --   -- 	-- { "p00f/nvim-ts-rainbow" },
  --   -- 	-- {
  --   -- 	--     "akinsho/flutter-tools.nvim",
  --   -- 	--     ft = "dart",
  --   -- 	--     config = "require('lsp.flutter')",
  --   -- 	-- },
  -- },

  -- quick list TODO
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    config = function()
      dofile(vim.g.base46_cache .. "git")
      require("plugins.configs.gitsigns")
    end,
  },

  {
    "tpope/vim-fugitive",
    -- cmd = "Git",
  },
  -- we dont need these because gitsigns.nvim implement all of them
  -- {
  --   "junegunn/gv.vim",
  --   dependencies = "tpope/vim-fugitive",
  -- },

  -- scrollbar TODO
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    config = function()
      dofile(vim.g.base46_cache .. "scrollbar")
      require("plugins.configs.nvimscrollbar")
    end,
  },

  -- fuzzy file finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings("telescope")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "telescope")
      require("plugins.configs.telescope")
    end,
  },

  -- file managing , picker etc
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = {
      "telescope.nvim",
    },
    init = function()
      require("core.utils").load_mappings("nvimtree")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "nvimtree")
      require("plugins.configs.nvimtree")
    end,
  },

  -- comment
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n" },
      { "gc", mode = "v" },
      { "gbc", mode = "n" },
      { "gb", mode = "v" },
    },
    init = function()
      require("core.utils").load_mappings("comment")
    end,
    config = function()
      require("plugins.configs.comment")
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
    lazy = false,
  },

  {
    "andymass/vim-matchup",
    lazy = false,
    init = function()
      -- may set any options here TODO
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "tpope/vim-surround",
    lazy = false,
  },

  {
    "tpope/vim-repeat",
    lazy = false,
  },
  -- folding
  {
    "kevinhwang91/nvim-ufo",
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      require("plugins.configs.ufo")
    end,
  },
  -- highlights characters to navigate
  {
    "unblevable/quick-scope",
    lazy = false,
    init = function()
      -- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
      vim.cmd([[ source ~/.config/nvim/configs/quickscope.vim ]])
    end,
  },

  -- lsp stuff
  {
    "jose-elias-alvarez/null-ls.nvim",
  },

  -- TODO
  -- use {
  --   "RishabhRD/nvim-lspcore.utils",
  --   requires = { "RishabhRD/popfix" },
  -- }

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
    },
    -- wants = {
    --   "nvim-cmp",
    --   "null-ls.nvim",
    --   "nvim-lspcore.utils",
    --   "typescript.nvim",
    -- },
    init = function()
      require("core.utils").lazy_load("nvim-lspconfig")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "lsp")
      require("plugins.lsp")
    end,
  },

  -- use {
  --   "ray-x/lsp_signature.nvim",
  --   after = "nvim-lspconfig",
  --   config = function()
  --     require("plugins.configs.lspsignature")
  --   end,
  -- }

  -- use {
  --   "folke/trouble.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   config = function()
  --     require("plugins.configs.trouble")
  --   end,
  -- }

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      {
        "mfussenegger/nvim-dap",
        init = function()
          require("core.utils").load_mappings("dap")
        end,
        config = function()
          require("plugins.configs.lspdap")
        end,
      },
    },
    config = function()
      require("plugins.configs.lspdapui")
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        config = function()
          require("plugins.configs.nvimluasnip")
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("plugins.configs.autopairs")
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  -- discord rich presence
  -- use "andweeb/presence.nvim"
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- key mapping
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", '"', "'", "`", "c", "v" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("core.utils").load_mappings("whichkey")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "whichkey")
      require("plugins.configs.whichkey")
    end,
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
