return {
  -- obsidian note taking
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    ft = "markdown",
    event = {
      "BufReadPre " .. vim.fn.expand("$OBSIDIAN_VAULT_PATH") .. "/**.md",
      "BufNewFile " .. vim.fn.expand("$OBSIDIAN_VAULT_PATH") .. "/**.md",
    },
    -- commands = {
    --   "ObsidianOpen",
    --   "ObsidianNew",
    --   "ObsidianQuickSwitch",
    --   "ObsidianFollowLink",
    --   "ObsidianBacklinks",
    --   "ObsidianToday",
    --   "ObsidianYesterday",
    --   "ObsidianTemplate",
    --   "ObsidianSearch",
    --   "ObsidianLink",
    --   "ObsidianLinkNew",
    -- },
    opts = {
      ui = {
        enable = true,
      },
      workspaces = {
        {
          name = "personal",
          path = vim.fn.expand("$OBSIDIAN_VAULT_PATH"),
        },
      },

      -- -- see below for full list of options 👇
      -- notes_subdir = "notes",
      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      disable_frontmatter = true,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "notes/daily",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },

      notes_subdir = "notes/uncategorized",
      new_notes_location = "notes_subdir",
      open_notes_in = "current",

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
    },
  },
}
