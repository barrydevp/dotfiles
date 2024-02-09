-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {
  "nvim-lua/plenary.nvim",

  {
    "barrydevp/base46",
    -- branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "barrydevp/ui.nvim",
    branch = "v2.0",
    lazy = false,
    init = function()
      dofile(vim.g.base46_cache .. "statusline")
    end,
  },

  {
    "barrydevp/nvterm",
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
    main = "ibl",
    init = function()
      require("core.utils").lazy_load("indent-blankline.nvim")
    end,
    -- opts = function()
    --   return require("plugins.configs.others").blankline
    -- end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      require("core.utils").load_mappings("blankline")
      -- require("indent_blankline").setup(opts)
      require("plugins.configs.blankline")
    end,
  },

  -- syntax analyzer and parser
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
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
    event = "BufRead",
    config = function()
      dofile(vim.g.base46_cache .. "scrollbar")

      require("plugins.configs.scrollbar")
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
      return require("plugins.configs.others").comment()
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
    event = "BufWinEnter",
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    -- lazy = false,
    init = function()
      -- may set any options here TODO
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "tpope/vim-surround",
    event = "BufReadPost",
  },

  {
    "tpope/vim-repeat",
    event = "InsertEnter",
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
    event = "BufRead",
    init = function()
      -- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
      vim.cmd([[ source ~/.config/nvim/configs/quickscope.vim ]])
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require("plugins.lsp.mason")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("plugins.configs.conform")
    end,
  },

  -- {
  --   "mfussenegger/nvim-lint",
  --   event = "BufReadPre",
  --   config = function()
  --     require("plugins.configs.conform")
  --   end,
  -- },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvimtools/none-ls.nvim",
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
    event = { "InsertEnter", "CmdlineEnter" },
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
        "hrsh7th/cmp-cmdline",
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")

      require("plugins.configs.cmp")
    end,
  },

  -- winbar for showing code context in status bar
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    config = function()
      require("plugins.configs.navic")
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
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 300
      require("core.utils").load_mappings("whichkey")
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")

      require("which-key").setup(opts)
    end,
  },

  -- ghost text (editing web browser input)
  -- {
  --   "subnut/nvim-ghost.nvim",
  --   lazy = false,
  --   init = function()
  --     -- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
  --     vim.cmd([[ source ~/.config/nvim/configs/nvim-ghost.vim ]])
  --   end,
  -- },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
