-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    hijack_cursor = true,
    update_focused_file = {
        enable = true,
    },
    renderer = {
        group_empty = true,
        full_name = true,
        hightlight_git = true,
    }
})

