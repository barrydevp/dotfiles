local icons = require("core.icons")

return {
  -- color, icons related stuff
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   opts = function()
  --     return { override = icons.devicons }
  --   end,
  -- },
  -- icons
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
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

  -- file minimap preview
  {
    "gorbit99/codewindow.nvim",
    event = "VeryLazy",
    opts = {
      auto_enable = false, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
      active_in_terminals = false, -- Should the minimap activate for terminal buffers
      exclude_filetypes = { "help", "oil", "octo" }, -- Choose certain filetypes to not show minimap on
      max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
      max_lines = nil, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
      minimap_width = 20, -- The width of the text part of the minimap
      use_lsp = true, -- Use the builtin LSP to show errors and warnings
      use_treesitter = true, -- Use nvim-treesitter to highlight the code
      use_git = true, -- Show small dots to indicate git additions and deletions
      width_multiplier = 4, -- How many characters one dot represents
      z_index = 1, -- The z-index the floating window will be on
      show_cursor = true, -- Show the cursor position in the minimap
      window_border = "none", -- The border style of the floating window (accepts all usual options)
      relative = "win", -- What will be the minimap be placed relative to, "win": the current window, "editor": the entire editor
      events = { "TextChanged", "InsertLeave", "DiagnosticChanged", "FileWritePost" }, -- Events that update the code window
    },
    config = function(_, opts)
      local codewindow = require("codewindow")
      codewindow.setup(opts)
      codewindow.apply_default_keybinds()
    end,
  },

  -- bufferline (tabs)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "catppuccin/nvim" },
    keys = {
      { "<C-t>p", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<C-t>P", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<C-t>co", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<C-t>ch", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<C-t>cl", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<C-t>h", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<C-t>l", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<C-t>H", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "<C-t>L", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
      {
        "<C-t>w",
        function()
          Snacks.bufdelete()
        end,
        desc = "close buffer",
      },
      {
        "<C-t>W",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "close others",
      },
      { "<A-{>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<A-}>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      {
        "<leader>x",
        function()
          Snacks.bufdelete()
        end,
        desc = "close buffer",
      },
      -- { "<C-w>W", utils.bufremove, desc = "close buffer" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        -- -- stylua: ignore
        -- close_command = function(n) utils.bufremove(n) end,
        -- -- stylua: ignore
        -- right_mouse_command = function(n) utils.bufremove(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_close_icon = false,
        show_buffer_close_icons = false,
        indicator = {
          style = "underline",
        },
        -- highlights = require("catppuccin.groups.integrations.bufferline").get(),
        diagnostics_indicator = function(_, _, diag)
          local diagnostics_icons = icons.diagnostics
          local ret = (diag.error and diagnostics_icons.Error .. diag.error .. " " or "")
            .. (diag.warning and diagnostics_icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
        hover = {
          enabled = false,
          delay = 200,
          reveal = { "close" },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
