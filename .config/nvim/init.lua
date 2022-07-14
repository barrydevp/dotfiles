local _modules = {
    "settings",
    "mappings",
    "plugins",
}

-- global context
_G.ctx = {}

for _, module in ipairs(_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
end
