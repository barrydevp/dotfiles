local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, autopairs_completion = pcall(require, "cmp")

if not (present1 or present2) then
  return
end

autopairs.setup {
  fast_wrap = {},
  disable_filetype = { "TelescopePrompt", "vim" },
}

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
autopairs_completion.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- autopairs.setup()
-- autopairs_completion.setup({
-- 	map_complete = true, -- insert () func completion
-- 	map_cr = true,
-- })
