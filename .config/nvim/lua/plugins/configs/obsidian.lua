return {
  ui = {
    enable = false,
  },
  workspaces = {
    {
      name = "personal",
      path = "/Users/apple/Library/Mobile Documents/iCloud~md~obsidian/Documents/vault",
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
}
