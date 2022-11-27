local ok, base46 = pcall(require, "base46")

if not ok then
  return
end

local options = {
  theme = "onedark",
}

-- options.theme = "rxyhn"
-- options.theme = "raidum"
-- options.theme = "gruvbox"
options.theme = "yoru"
-- options.theme = "ayu-dark"

base46.setup(options)
