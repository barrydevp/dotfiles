local utils = require("dropbar.utils")

return {
  -- general = {
  --   enable = function(buf, win)
  --     return vim.fn.win_gettype(win) == ""
  --       and vim.wo[win].winbar == ""
  --       and vim.bo[buf].bt == ""
  --       and (
  --         vim.bo[buf].ft == "markdown"
  --         or (
  --           buf
  --             and vim.api.nvim_buf_is_valid(buf)
  --             and (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft))
  --             and true
  --           or false
  --         )
  --       )
  --   end,
  -- },
  bar = {
    hover = false,
    ---@type dropbar_source_t[]|fun(buf: integer, win: integer): dropbar_source_t[]
    sources = function(buf, _)
      local sources = require("dropbar.sources")
      if vim.bo[buf].ft == "markdown" then
        return {
          -- sources.path,
          sources.markdown,
        }
      end
      if vim.bo[buf].buftype == "terminal" then
        return {
          sources.terminal,
        }
      end
      return {
        -- sources.path,
        utils.source.fallback {
          sources.lsp,
          sources.treesitter,
        },
      }
    end,
    -- padding = {
    --   left = 1,
    --   right = 1,
    -- },
    -- pick = {
    --   pivots = "abcdefghijklmnopqrstuvwxyz",
    -- },
    -- truncate = true,
  },

  -- sources = {
  --   path = {
  --     relative_to = function(_, win)
  --       -- Workaround for Vim:E5002: Cannot find window number
  --       local ok, cwd = pcall(vim.fn.getcwd, win)
  --       return ok and cwd or vim.fn.getcwd()
  --     end,
  --   },
  -- },
}
