return {
  -- color, icons related stuff
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require("core.icons").devicons }
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
}
