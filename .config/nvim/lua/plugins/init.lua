local config = require("core.utils").load_config()

-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local plugins = {
  "nvim-lua/plenary.nvim",

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("plugins.configs.catppuccin")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },

  {
    "barrydevp/nvterm",
    init = function()
      require("core.utils").load_mappings("nvterm")
    end,
    config = function(_, opts)
      require("nvterm").setup(opts)
    end,
  },

  -- color, icons related stuff
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require("core.icons").devicons }
    end,
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
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
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function(_, opts)
      require("plugins.configs.blankline")
    end,
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

  -- syntax analyzer and parser
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
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
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  -- quick list TODO
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = function()
      return require("plugins.configs.bqf")
    end,
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
    config = function()
      require("plugins.configs.gitsigns")
    end,
  },

  -- scrollbar TODO
  -- {
  --   "petertriho/nvim-scrollbar",
  --   event = "BufRead",
  --   config = function()
  --
  --     require("plugins.configs.scrollbar")
  --   end,
  -- },

  -- fuzzy file finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    cmd = "Telescope",
    init = function()
      -- load mapping
      require("core.utils").load_mappings("telescope")
    end,
    opts = function()
      return require("plugins.configs.telescope")
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
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
    "echasnovski/mini.surround",
    event = "BufReadPost",
    -- lazy = false,
    config = function()
      require("mini.surround").setup()
    end,
  },

  -- {
  --   "tpope/vim-repeat",
  --   event = "InsertEnter",
  -- },

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
  -- {
  --   "unblevable/quick-scope",
  --   -- event = "BufRead",
  --   event = "VeryLazy",
  --   init = function()
  --     -- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
  --     vim.cmd([[ source ~/.config/nvim/configs/quickscope.vim ]])
  --   end,
  -- },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require("plugins.lsp.mason")
    end,
    config = function(_, opts)
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
    -- event = { "BufWritePre" },
    cmd = "ConformInfo",
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

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     hint_prefix = "",
  --     hint_scheme = "LspSignatureActiveParameter",
  --     hint_inline = function()
  --       return false
  --     end,
  --     floating_window = false,
  --     floating_window_above_cur_line = false,
  --     bind = true,
  --     hi_parameter = "LspSignatureActiveParameter",
  --   },
  --   config = function(_, opts)
  --     require("lsp_signature").setup(opts)
  --   end,
  -- },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvimtools/none-ls-extras.nvim" },
        config = function()
          require("plugins.configs.nullls")
        end,
      },
    },
    config = function()
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
        "hrsh7th/cmp-calc",
      },
    },
    config = function(_, opts)
      require("plugins.configs.cmp")
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
  --     return require("plugins.configs.dropbar")
  --   end,
  --   -- config = function(_, opts)
  --   --   require("dropbar").setup(opts)
  --   -- end,
  -- },

  -- discord rich presence
  -- use "andweeb/presence.nvim"
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- key mapping
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
  --   init = function()
  --     require("core.utils").load_mappings("whichkey")
  --   end,
  --   cmd = "WhichKey",
  --   config = function(_, opts)
  --     require("which-key").setup(opts)
  --   end,
  -- },

  -- AI code generation
  {
    "codota/tabnine-nvim",
    -- dir = "/Users/apple/Dev/github.com/barrydevp/tabnine-nvim",
    build = "./dl_binaries.sh",
    lazy = false,
    cond = config.code.ai == "tabnine",
    opts = function()
      return require("plugins.configs.tabnine")
    end,
    config = function(_, opts)
      require("tabnine").setup(opts)
    end,
  },

  {
    "github/copilot.vim",
    event = "InsertEnter",
    cond = config.code.ai == "copilotvim",
    init = function()
      return require("plugins.configs.copilotvim")
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = config.code.ai == "copilot",
    opts = function()
      return require("plugins.configs.copilot")
    end,
    config = function(_, opts)
      require("copilot").setup(opts)

      -- load highlights
      vim.api.nvim_command("highlight link CopilotAnnotation AIAnnotation")
      vim.api.nvim_command("highlight link CopilotSuggestion AISuggestion")
    end,
  },

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

      -- see below for full list of optional dependencies 👇
    },
    opts = function()
      return require("plugins.configs.obsidian")
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

require("lazy").setup(plugins, config.lazy_nvim)
