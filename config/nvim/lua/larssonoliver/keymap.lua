vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("i", "<S-Tab>", "<C-d>")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<C-_>", "<cmd>CommentToggle<CR>")
vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>")

vim.keymap.set("n", "<C-H>", "<C-W>h")
vim.keymap.set("n", "<C-J>", "<C-W>j")
vim.keymap.set("n", "<C-K>", "<C-W>k")
vim.keymap.set("n", "<C-L>", "<C-W>l")

-- Telescope
vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files, {})
vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>ps", require("telescope.builtin").live_grep, {})

-- clangd
vim.keymap.set("n", "<leader>gh", ":ClangdSwitchSourceHeader<CR>", {})
