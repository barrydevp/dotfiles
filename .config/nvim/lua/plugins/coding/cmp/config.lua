local cmp = require("cmp")
local luasnip = require("luasnip")
local icons = require("core.icons").kinds

local formatting_style = {
  -- -- default fields order i.e completion word + item.kind + item.kind icons
  -- fields = { "abbr", "kind", "menu" },
  --
  -- format = function(_, item)
  --   local icon = icons[item.kind] or ""
  --
  --   item.menu = nil
  --   item.kind = icon .. " " .. item.kind
  --
  --   return item
  -- end,
  fields = { "kind", "abbr", "menu" },
  format = function(_, item)
    if icons[item.kind] then
      item.kind = icons[item.kind]
    end

    local widths = {
      abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
      menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
    }

    for key, width in pairs(widths) do
      if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
        item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
      end
    end

    return item
  end,
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local defaults = require("cmp.config.default")()

local opts = {
  completion = {
    -- completeopt = "menu,menuone",
    completeopt = "menu,menuone,noinsert",
  },
  window = {
    completion = {
      col_offset = -2,
      side_padding = 0,
    },
    -- completion = cmp.config.window.bordered {},
    -- documentation = cmp.config.window.bordered {},
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  formatting = formatting_style,

  mapping = cmp.mapping.preset.insert {
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end, {
      "i",
    }),
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end, {
      "i",
    }),
    ["<C-c>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-e>"] = cmp.mapping(
      --- Integrated with copilot, tabnine
      function(fallback)
        -- execute AI Code generation
        if require("plugins.coding.cmp.aicmp").accept() then
          return
        end

        -- usual close completion menu
        if cmp.visible() then
          cmp.abort()
        else
          fallback()
        end
      end,
      { "i", "s" }
    ),
    ["<CR>"] = cmp.mapping(
      -- If nothing is selected (including preselections) add a newline as usual.
      -- If something has explicitly been selected by the user, select its
      function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
        else
          fallback()
        end
      end,
      { "i", "s" }
    ),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          cmp.confirm {}
        end
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- elseif has_words_before() then
        --   cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    -- { name = "nvim_lua" },
    { name = "path" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  sorting = defaults.sorting,
  experimental = {
    -- ghost_text = true,
    -- ghost_text = {
    --   hl_group = "Comment",
    -- },
  },
}

require("cmp").setup(opts)

local cmdline_mapping = {
  ["<Tab>"] = cmp.mapping(function()
    if cmp.visible() then
      if #cmp.get_entries() == 1 then
        cmp.confirm { select = true }
      else
        cmp.select_next_item()
      end
    else
      cmp.complete()
    end
  end, { "c" }),
  ["<S-Tab>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_prev_item()
    else
      cmp.complete()
    end
  end, { "c" }),
}

-- Use bkffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  mapping = cmdline_mapping,
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  mapping = cmdline_mapping,
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

return opts
