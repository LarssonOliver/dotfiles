local remap = require("larssonoliver.keymap")
local nnoremap = remap.nnoremap
local vnoremap = remap.vnoremap
local inoremap = remap.inoremap
-- local xnoremap = remap.xnoremap
local nmap = remap.nmap
if vim.g.loaded_netrw == 1 then
    nnoremap("<leader>pv", "<cmd>Ex<CR>")
else
    nnoremap("<leader>pv", "<cmd>NvimTreeFocus<CR>")
end

inoremap("<S-Tab>", "<C-d>")

nnoremap("<leader>x", "<cmd>!chmod +x %<CR>")

nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")

nnoremap("<C-_>", "<cmd>CommentToggle<CR>")
vnoremap("<C-_>", ":'<,'>CommentToggle<CR>")


-- Telescope
nnoremap("<C-p>", function()
    require("telescope.builtin").git_files()
end)
nnoremap("<leader>pf", function()
    require("telescope.builtin").find_files()
end)
nnoremap("<leader>ps", function()
    require("telescope.builtin").live_grep()
end)
nnoremap("<leader>pw", function()
    require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end)

