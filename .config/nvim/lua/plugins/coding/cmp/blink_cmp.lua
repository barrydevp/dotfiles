return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip" },
      -- { "fang2hou/blink-copilot" },
    },
    event = { "VeryLazy" },
    -- use a release tag to download pre-built binaries
    version = "*",

    opts_extend = { "sources.default" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = {
          -- "copilot",
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
        providers = {
          -- copilot = {
          --   name = "copilot",
          --   module = "blink-copilot",
          --   score_offset = 100,
          --   async = true,
          -- },
        },
      },

      snippets = { preset = "luasnip" },

      keymap = {
        preset = "default",
        ["<C-b>"] = {},
        ["<C-f>"] = {},
        ["<C-k>"] = {},

        ["<C-p>"] = { "show", "select_prev", "fallback" },
        ["<C-n>"] = { "show", "select_next", "fallback" },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "inherit",
          ["<C-b>"] = {},
          ["<C-f>"] = {},
          ["<C-k>"] = {},
          ["<C-a>"] = {},
          ["<C-e>"] = {},
          ["<C-p>"] = {},
          ["<C-n>"] = {},

          ["<C-i>"] = {
            function(cmp)
              if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
                return cmp.accept()
              end
            end,
            "show_and_insert",
            "select_next",
          },
          ["<Tab>"] = {
            function(cmp)
              if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
                return cmp.accept()
              end
            end,
            "show_and_insert",
            "select_next",
          },
          ["<S-Tab>"] = { "show_and_insert", "select_prev" },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
        completion = {
          trigger = { show_on_blocked_trigger_characters = {}, show_on_x_blocked_trigger_characters = {} },
          list = { selection = { preselect = true, auto_insert = true } },
          menu = { auto_show = false },
          ghost_text = { enabled = true },
        },
      },

      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = function(ctx)
              return ctx.mode == "cmdline"
            end,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            -- treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = {
          enabled = false,
        },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
    },
    config = function(_, opts)
      local aicmpFn = require("plugins.coding.cmp.aicmp")

      opts.keymap["<C-y>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        -- aicmpFn.accept,
        -- "snippet_forward",
        "fallback",
      }

      opts.keymap["<C-e>"] = {
        "hide",
        aicmpFn.dismiss,
        "fallback",
      }

      opts.keymap["<Tab>"] = {
        aicmpFn.accept,
        "snippet_forward",
        "fallback",
      }

      opts.keymap["<S-Tab>"] = {
        "snippet_backward",
        "fallback",
      }

      require("blink.cmp").setup(opts)
    end,
  },
}
