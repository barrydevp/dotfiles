local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "scss",
        "bash",
        "lua",
        "json",
        "python",
        "go",
        "gomod",
        "yaml",
        "toml",
        "java",
        "c",
        "cpp",
    },
    highlight = {
        enable = true,
        use_languagetree = true
    }
}
