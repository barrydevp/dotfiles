local config = require("core.utils").load_config().ui

if config.tabufline.enabled then
  require("core.ui.tabufline.lazyload")
end
