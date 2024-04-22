return {
  -- snippets + cmp related
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        -- "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
      },
    },
    -- enabled = false,
    opts = {
      auto_brackets = {},
    },
    config = function(_, opts)
      require("plugins.coding.cmp.config")

      -- local cmp = require("cmp")
      -- local Kind = cmp.lsp.CompletionItemKind
      -- cmp.event:on("confirm_done", function(event)
      --   local disabled = vim.tbl_get(opts, "auto_brackets", vim.bo.filetype)
      --
      --   if disabled ~= nil and disabled then
      --     return
      --   end
      --
      --   local entry = event.entry
      --   local item = entry:get_completion_item()
      --   if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
      --     local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
      --     vim.api.nvim_feedkeys(keys, "i", true)
      --   end
      -- end)
    end,
  },

  {
    -- snippet plugin
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },

    opts = function()
      -- local types = require("luasnip.util.types")

      return {
        -- ext_opts = {
        --   [types.insertNode] = {
        --     active = {
        --       hl_group = "SnippetActive",
        --     },
        --     passive = {
        --       hl_group = "SnippetPassive",
        --     },
        --   },
        --   [types.choiceNode] = {
        --     active = {
        --       hl_group = "SnippetActive",
        --     },
        --     passive = {
        --       hl_group = "SnippetPassive",
        --     },
        --   },
        -- },
        history = true,
        updateevents = "TextChanged,TextChangedI",
      }
    end,
    config = function(_, opts)
      require("luasnip").setup(opts)

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      -- require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
      -- require("luasnip.loaders.from_vscode").lazy_load { paths = "your path!" }
      -- require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

      -- snipmate format
      -- require("luasnip.loaders.from_snipmate").load()
      -- require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

      -- lua format
      -- require("luasnip.loaders.from_lua").load()
      -- require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }
    end,
  },

  -- autopairing of (){}[] etc
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
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

  -- {
  --   "echasnovski/mini.pairs",
  --   event = "VeryLazy",
  --   opts = {},
  --   keys = {
  --     {
  --       "<leader>up",
  --       function()
  --         vim.g.minipairs_disable = not vim.g.minipairs_disable
  --         if vim.g.minipairs_disable then
  --           print("Disabled auto pairs")
  --         else
  --           print("Enabled auto pairs")
  --         end
  --       end,
  --       desc = "Toggle Auto Pairs",
  --     },
  --   },
  -- },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
}
