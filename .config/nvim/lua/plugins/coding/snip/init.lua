return {
  {
    -- snippet plugin
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },

    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      -- vscode format
      -- require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = { "./lua/plugins/coding/snip/snippets" } }
      -- require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
      -- require("luasnip.loaders.from_vscode").lazy_load { paths = "your path!" }
      -- require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

      -- snipmate format
      -- require("luasnip.loaders.from_snipmate").load()
      -- require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

      -- lua format
      -- require("luasnip.loaders.from_lua").load()
      -- require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

      Core.snippet_stop = function()
        if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
          require("luasnip").unlink_current()
          return true
        end
      end
    end,
  },
}
