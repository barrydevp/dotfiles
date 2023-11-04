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
  },

  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings("nvterm")
    end,
    config = function(_, opts)
      require("base46.term")
      require("nvterm").setup(opts)
    end,
  },

  -- color, icons related stuff
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require("nvchad.icons.devicons") }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      require("core.utils").lazy_load("nvim-colorizer.lua")
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- indent decorator
  {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    init = function()
      require("core.utils").lazy_load("indent-blankline.nvim")
    end,
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      require("core.utils").load_mappings("blankline")
      require("indent_blankline").setup(opts)
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
    dependencies = {
      "tpope/vim-fugitive",
    },
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings("telescope")
    end,
    opts = function()
      return require("plugins.configs.telescope")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")

      local telescope = require("telescope")
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings("nvimtree")
    end,
    opts = function()
      return require("plugins.configs.nvimtree")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")

      require("nvim-tree").setup(opts)
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
    config = function(_, opts)
      require("Comment").setup(opts)
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
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    init = function()
      -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      -- vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
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

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
    },
    init = function()
      require("core.utils").lazy_load("nvim-lspconfig")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "lsp")

      require("plugins.lsp")
    end,
  },

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
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
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
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")

      return require("plugins.configs.cmp")
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
    keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("core.utils").load_mappings("whichkey")
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")

      require("which-key").setup(opts)
    end,
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
