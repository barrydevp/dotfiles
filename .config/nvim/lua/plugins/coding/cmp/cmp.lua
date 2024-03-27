local cmp = require("cmp")
local luasnip = require("luasnip")
local icons = require("core.icons").lspkind

local formatting_style = {
  -- default fields order i.e completion word + item.kind + item.kind icons
  fields = { "abbr", "kind", "menu" },

  format = function(_, item)
    local icon = icons[item.kind] or ""

    item.menu = nil
    item.kind = icon .. " " .. item.kind

    return item
  end,
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local options = {
  completion = {
    completeopt = "menu,menuone",
  },
  -- window = {
  --   completion = cmp.config.window.bordered {},
  --   documentation = cmp.config.window.bordered {},
  -- },
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
    -- ["<C-n>"] = cmp.mapping(function(fallback)
    --   -- if completion menu is visible, select next item
    --   if not cmp.select_next_item { behavior = cmp.SelectBehavior.Select } then
    --     if not cmp.complete() then -- else open it
    --       local release = require("cmp").core:suspend()
    --       fallback() -- fallback if not
    --       vim.schedule(release)
    --     end
    --   end
    -- end, {
    --   "i",
    --   "s",
    -- }),
    -- ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    -- ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
    -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    -- ["<C-u>"] = cmp.mapping.scroll_docs(4),
    -- ["<C-Space>"] = cmp.mapping.complete(), -- <C-Space> is used for tmux prefix
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
    -- { name = "copilot", option = {
    --   event = { "InsertEnter", "LspAttach" },
    --   fix_pairs = true,
    -- } },
    { name = "nvim_lsp" },
    -- { name = "nvim_lua" },
    { name = "calc" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  experimental = {
    -- ghost_text = true,
    -- ghost_text = {
    --   hl_group = "Comment",
    -- },
  },
}

require("cmp").setup(options)

local cmdline_mapping = cmp.mapping.preset.cmdline {
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
