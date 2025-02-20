return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip" },
    },

    -- use a release tag to download pre-built binaries
    version = "*",

    opts_extend = { "sources.default" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },

      keymap = {
        preset = "default",
        ["<C-b>"] = {},
        ["<C-f>"] = {},
        ["<C-k>"] = {},

        ["<C-p>"] = { "show", "select_prev", "fallback" },
        ["<C-n>"] = { "show", "select_next", "fallback" },

        ["<C-e>"] = { "hide", "fallback" },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "default",
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
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

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    config = function(_, opts)
      local aicmpFn = require("plugins.coding.cmp.aicmp")

      opts.keymap["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
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
