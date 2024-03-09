local cmp = require("cmp")
local luasnip = require("luasnip")
local config = require("core.utils").load_config()
local cmp_ui = config.ui.cmp
local cmp_style = cmp_ui.style

local field_arrangement = {
  atom = { "kind", "abbr", "menu" },
  atom_colored = { "kind", "abbr", "menu" },
}

local formatting_style = {
  -- default fields order i.e completion word + item.kind + item.kind icons
  fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

  format = function(_, item)
    local icons = require("core.icons").lspkind
    local icon = (cmp_ui.icons and icons[item.kind]) or ""

    if cmp_style == "atom" or cmp_style == "atom_colored" then
      icon = " " .. icon .. " "
      item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
      item.kind = icon
    else
      icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
      item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
    end

    return item
  end,
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local options = {
  completion = {
    completeopt = "menu,menuone",
  },

  window = {
    completion = cmp.config.window.bordered {
      side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
      -- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
      -- scrollbar = false,
    },
    documentation = cmp.config.window.bordered {
      -- border = border("CmpDocBorder"),
      -- winhighlight = "Normal:CmpDoc",
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  formatting = formatting_style,

  mapping = cmp.mapping.preset.insert {
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    -- ["<C-e>"] = cmp.mapping.abort(),
    ["<C-e>"] = cmp.mapping(
      --- Integrated with copilot, tabnine
      function(fallback)
        -- execute AI Code generation
        -- tabnine
        if config.options.ai_code == "tabnine" and require("plugins.configs.tabnine").accept() then
          return
        -- copilot
        elseif config.options.ai_code == "copilot" and require("plugins.configs.copilot").accept() then
          return
        end

        -- usual close completion menu
        if cmp.visible() then
          cmp.abort()
        else
          fallback()
        end
      end,
      {
        "i",
        "s",
      }
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
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    -- { name = "nvim_lua" },
    { name = "calc" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  -- experimental = {
  --   ghost_text = {
  --     hl_group = "Comment",
  --   },
  -- },
}

if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
  options.window.completion.border = border("CmpBorder")
end

require("cmp").setup(options)

local cmdline_mapping = cmp.mapping.preset.cmdline {
  ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "c" }),
  -- ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "c" }),
  -- ["<CR>"] = cmp.mapping.confirm {
  --   -- behavior = cmp.ConfirmBehavior.Insert,
  --   select = true,
  -- },
  ["<Tab>"] = cmp.mapping(function(callback)
    if cmp.visible() then
      if #cmp.get_entries() == 1 then
        cmp.confirm { select = true }
      else
        cmp.select_next_item()
      end
    else
      cmp.complete()
      if #cmp.get_entries() == 1 then
        cmp.confirm { select = true }
      end
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

return options
