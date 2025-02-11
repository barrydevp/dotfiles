return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {--[[ things you want to change go here]]
      open_mapping = [[<c-\>]],
      shade_filetypes = {},
      direction = "float",
      autochdir = true,
      persist_mode = false,
      insert_mappings = false,
      start_in_insert = true,
      -- winbar = { enabled = true },
      highlights = {
        FloatBorder = { link = "FloatBorder" },
        NormalFloat = { link = "NormalFloat" },
      },
      float_opts = {
        border = "curved",
        winblend = 3,
      },
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.45)
        end
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      local on_open = function(term)
        vim.keymap.set("t", "<C-\\>", function()
          term:toggle()
        end, { desc = "Toggle terminal (t)", buffer = term.bufnr })
      end

      local vert_term = Terminal:new {
        hidden = true,
        direction = "vertical",
        on_open = on_open,
      }

      local float_term = Terminal:new {
        hidden = true,
        direction = "float",
        on_open = on_open,
      }

      vim.keymap.set("n", "<leader>tv", function()
        vert_term:toggle()
      end, { desc = "Toggle vertical terminal" })

      vim.keymap.set("n", "<leader>tt", function()
        float_term:toggle()
      end, { desc = "Toggle float terminal" })
    end,
  },
}
