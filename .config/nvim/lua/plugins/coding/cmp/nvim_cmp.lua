local config = require("core.config")

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
        -- {
        --   "zbirenbaum/copilot-cmp",
        --   cond = config.coding.ai == "copilot",
        --   config = function()
        --     require("copilot_cmp").setup()
        --   end,
        -- },
      },
    },
    -- enabled = false,
    opts = {
      auto_brackets = {},
    },
    config = function(_, opts)
      require("plugins.coding.cmp.nvimcmp_config")

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
}
