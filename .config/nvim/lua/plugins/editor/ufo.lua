local Utils = require("utils")

local ftMap = {
  vim = "indent",
  python = { "indent" },
  git = "",
}

local function fold_virt_text_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d ~ "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    init = function()
      -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      -- vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        c = { "comment", "region" },
      },
      preview = {
        win_config = {
          border = { "", "", "", "", "", "", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype] or "treesitter"
      end,
      fold_virt_text_handler = fold_virt_text_handler,
    },
    config = function(_, opts)
      local ufo = require("ufo")
      ufo.setup(opts)

      Utils.set_keymaps {
        ["n"] = {
          { "zR", ufo.openAllFolds, { desc = "open all folds" } },
          { "zM", ufo.closeAllFolds, { desc = "close all folds" } },
          { "zr", ufo.openFoldsExceptKinds, { desc = "open folds except kinds" } },
          { "zm", ufo.closeFoldsWith, { desc = "close folds with" } }, -- closeAllFolds == closeFoldsWith(0)
          {
            "K",
            function()
              local winid = ufo.peekFoldedLinesUnderCursor()
              if not winid then
                Utils.lsp.hover()
                -- vim.cmd([[ Lspsaga hover_doc ]])
              end
            end,
            { desc = "hover" },
          },
        },
      }
    end,
  },
}
