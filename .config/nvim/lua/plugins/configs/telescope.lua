local present, telescope = pcall(require, "telescope")

if not present then
  return
end

local default = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
}

telescope.setup(default)

local extensions = { "themes", "terms" }

pcall(function()
  for _, ext in ipairs(extensions) do
    telescope.load_extension(ext)
  end
end)
