vim.g.mapleader = " "

if vim.g.loaded_netrw == 1 then
    vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
else
    vim.keymap.set("n", "<leader>pv", "<cmd>NvimTreeFocus<CR>")
end

vim.keymap.set("i", "<S-Tab>", "<C-d>")

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<C-_>", "<cmd>CommentToggle<CR>")
vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>")

-- Telescope
vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files, {})
vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>ps", require("telescope.builtin").live_grep, {})

