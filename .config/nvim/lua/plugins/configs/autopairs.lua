local autopairs = require("nvim-autopairs")
local autopairs_completion = require("cmp")

autopairs.setup {
  fast_wrap = {},
  disable_filetype = { "TelescopePrompt", "vim" },
}

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
autopairs_completion.event:on("confirm_done", cmp_autopairs.on_confirm_done())
