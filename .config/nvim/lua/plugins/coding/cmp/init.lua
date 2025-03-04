return {
  -- autopairing of (){}[] etc
  -- {
  --   "windwp/nvim-autopairs",
  --   event = "VeryLazy",
  --   opts = {
  --     fast_wrap = {},
  --     disable_filetype = { "TelescopePrompt", "vim" },
  --   },
  --   config = function(_, opts)
  --     require("nvim-autopairs").setup(opts)
  --
  --     -- setup cmp for autopairs
  --     local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  --     require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --   end,
  -- },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    keys = {
      {
        "<leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            print("Disabled auto pairs")
          else
            print("Enabled auto pairs")
          end
        end,
        desc = "Toggle Auto Pairs",
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },

  { import = "plugins.coding.cmp.blink_cmp" },
}
