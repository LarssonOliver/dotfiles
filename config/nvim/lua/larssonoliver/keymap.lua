vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("i", "<S-Tab>", "<C-d>")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<C-_>", "<cmd>CommentToggle<CR>")
vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>")

vim.keymap.set("n", "<C-H>", "<cmd> TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-J>", "<cmd> TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-K>", "<cmd> TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-L>", "<cmd> TmuxNavigateRight<CR>")

-- Telescope
vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files, {})
vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>ps", require("telescope.builtin").live_grep, {})

-- clangd
vim.keymap.set("n", "<leader>gh", ":ClangdSwitchSourceHeader<CR>", {})
