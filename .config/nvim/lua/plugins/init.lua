-- Load all plugins
local present, packer = pcall(require, "packer")

if not present then
  return
end

vim.cmd("packadd packer.nvim")

-- packer init options
packer.init {
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 6000 },
  display = {
    working_sym = "ﲊ",
    error_sym = "✗ ",
    done_sym = " ",
    removed_sym = " ",
    moved_sym = "",
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

-- using { } for using different branch , loading plugin with certain commands etc
packer.startup(function(use)
  use {
    "lewis6991/impatient.nvim",
  }

  use {
    "nvim-lua/plenary.nvim",
    module = "plenary",
  }

  use {
    "wbthomason/packer.nvim",
    cmd = require("utils.lazy_load").packer_cmds,
    config = function()
      require("plugins")
    end,
  }

  use {
    "barrydevp/base46",
    config = function()
      require("plugins.configs.base46")
    end,
  }

  use {
    "barrydevp/ui.nvim",
    after = { "base46" },
    config = function()
      local ok, nvchad_ui = pcall(require, "nvchad_ui")

      if ok then
        nvchad_ui.setup()
      end

      require("utils.mapping").load_mappings("tabufline")
    end,
  }

  -- color, icons related stuff
  use {
    "kyazdani42/nvim-web-devicons",
    after = "ui.nvim",
    module = "nvim-web-devicons",
    config = function()
      require("plugins.configs.webdevicons")
    end,
  }

  use {
    "norcalli/nvim-colorizer.lua",
    opt = true,
    setup = function()
      require("utils.lazy_load").on_file_open("nvim-colorizer.lua")
    end,
    config = function()
      require("plugins.configs.colorizer")
    end,
  }

  -- indent decorator
  use {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "BufRead",
    opt = true,
    setup = function()
      require("utils.lazy_load").on_file_open("indent-blankline.nvim")
      require("utils.mapping").load_mappings("blankline")
    end,
    config = function()
      require("plugins.configs.blankline")
    end,
  }

  -- syntax analyzer and parser
  use {
    "nvim-treesitter/nvim-treesitter",
    -- event = "BufRead",
    run = ":TSUpdate",
    opt = true,
    module = "nvim-treesitter",
    cmd = require("utils.lazy_load").treesitter_cmds,
    config = function()
      require("plugins.configs.treesitter")
    end,
    requires = {
      -- 	-- "windwp/nvim-ts-autotag",
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      -- { "jose-elias-alvarez/typescript.nvim" },
      -- 	-- { "Hoffs/omnisharp-extended-lsp.nvim" },
      -- 	-- {
      -- 	--     "nvim-treesitter/playground",
      -- 	--     cmd = "TSHighlightCapturesUnderCursor",
      -- 	-- },
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      -- 	-- { "p00f/nvim-ts-rainbow" },
      -- 	-- {
      -- 	--     "akinsho/flutter-tools.nvim",
      -- 	--     ft = "dart",
      -- 	--     config = "require('lsp.flutter')",
      -- 	-- },
    },
  }

  -- quick list TODO
  use {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  }

  -- git stuff
  use {
    "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    setup = function()
      require("utils.lazy_load").gitsigns()
    end,
    config = function()
      require("plugins.configs.gitsigns")
    end,
  }

  use {
    "tpope/vim-fugitive",
    cmd = "Git",
  }
  use { "junegunn/gv.vim" }

  -- scrollbar TODO
  use {
    "petertriho/nvim-scrollbar",
    after = { "base46" },
    config = function()
      require("plugins.configs.nvimscrollbar")
    end,
  }

  -- fuzzy file finding
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    -- requires = {
    --   { "nvim-lua/plenary.nvim" },
    --   {
    --     "nvim-telescope/telescope-fzf-native.nvim",
    --     run = "make",
    --   },
    --   {
    --     "nvim-telescope/telescope-media-files.nvim",
    --     setup = function()
    --       require("mappings").telescope_media()
    --     end,
    --   },
    -- },
    config = function()
      require("plugins.configs.telescope")
    end,
    setup = function()
      require("utils.mapping").load_mappings("telescope")
    end,
  }

  -- file managing , picker etc
  use {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    after = "telescope.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    setup = function()
      require("utils.mapping").load_mappings("nvimtree")
    end,
    config = function()
      require("plugins.configs.nvimtree")
    end,
  }

  -- editorconfig
  use { "editorconfig/editorconfig-vim" }
  -- auto detect indent
  use { "tpope/vim-sleuth" }

  -- comment
  use {
    "numToStr/Comment.nvim",
    -- module = "Comment",
    -- keys = { "gc", "gb" },
    setup = function()
      require("utils.mapping").load_mappings("comment")
    end,
    config = function()
      require("plugins.configs.comment")
    end,
  }

  -- editor
  use {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.autopairs")
    end,
  }

  use {
    "andymass/vim-matchup",
    opt = true,
    setup = function()
      -- may set any options here TODO
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  }

  use {
    "tpope/vim-surround",
  }

  use {
    "tpope/vim-repeat",
  }

  -- lsp stuff
  use {
    "jose-elias-alvarez/null-ls.nvim",
  }

  -- TODO
  -- use {
  --   "RishabhRD/nvim-lsputils",
  --   requires = { "RishabhRD/popfix" },
  -- }

  use {
    "neovim/nvim-lspconfig",
    opt = true,
    -- wants = {
    --   "nvim-cmp",
    --   "null-ls.nvim",
    --   "nvim-lsputils",
    --   "typescript.nvim",
    -- },
    setup = function()
      require("utils.lazy_load").on_file_open("nvim-lspconfig")
    end,
    config = function()
      require("plugins.lsp")
    end,
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      -- "jose-elias-alvarez/typescript.nvim",
    },
  }

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

  use {
    "mfussenegger/nvim-dap",
    setup = function()
      require("utils.mapping").load_mappings("dap")
    end,
    config = function()
      require("plugins.configs.lspdap")
    end,
  }

  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("plugins.configs.lspdapui")
    end,
  }

  -- load luasnips + cmp related in insert mode only
  use {
    "rafamadriz/friendly-snippets",
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter",
  }

  use {
    "hrsh7th/nvim-cmp",
    after = "friendly-snippets",
    config = function()
      require("plugins.configs.cmp")
    end,
  }

  use {
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.nvimluasnip")
    end,
  }

  use {
    "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip",
  }

  use {
    "hrsh7th/cmp-nvim-lua",
    after = "cmp_luasnip",
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    after = "cmp-nvim-lua",
  }

  use {
    "hrsh7th/cmp-buffer",
    after = "cmp-nvim-lsp",
  }

  use {
    "hrsh7th/cmp-path",
    after = "cmp-buffer",
  }

  -- discord rich presence
  -- use "andweeb/presence.nvim"
  use {
    "christoomey/vim-tmux-navigator",
  }

  -- key mapping
  use {
    "folke/which-key.nvim",
    config = function()
      require("plugins.configs.whichkey")
    end,
    setup = function()
      require("utils.mapping").load_mappings("whichkey")
    end,
  }
end, {
  display = {
    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  },
})
