return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = { --[[ things you want to change go here]]
      -- open_mapping = [[<c-\>]],
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
      local _current_term = nil

      local on_open = function(term)
        -- vim.keymap.set("t", "<C-\\>", function()
        --   term:toggle()
        -- end, { desc = "Toggle terminal", buffer = term.bufnr })
        _current_term = term
      end

      local vert_term = Terminal:new {
        hidden = true,
        direction = "vertical",
        on_open = on_open,
      }

      local hori_term = Terminal:new {
        hidden = true,
        direction = "horizontal",
        on_open = on_open,
        size = 20,
      }

      local float_term = Terminal:new {
        hidden = true,
        direction = "float",
        on_open = on_open,
      }

      _current_term = hori_term

      vim.keymap.set({ "n", "t" }, "<C-\\>", function()
        if _current_term then
          _current_term:toggle()
        end
      end, { desc = "Toggle terminal" })

      vim.keymap.set("n", "<leader>tv", function()
        vert_term:toggle()
      end, { desc = "Toggle vertical terminal" })

      vim.keymap.set("n", "<leader>th", function()
        hori_term:toggle()
      end, { desc = "Toggle horizontal terminal" })

      vim.keymap.set("n", "<leader>tt", function()
        float_term:toggle()
      end, { desc = "Toggle float terminal" })
    end,
  },
}
