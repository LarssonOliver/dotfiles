-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    sync_install = false,

    highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
    },
})

-- Nvim comment 
require("nvim_comment").setup({
    comment_empty = false,
    create_mappings = false,
})

-- Lualine
require("lualine").setup({
    options = {
        theme = vim.g.larssonoliver_colorscheme
    }
})

