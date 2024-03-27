local config = require("core.config").ui

if config.tabufline.enabled then
  require("plugins.ui.tabufline.lazyload")
end

return {}
