local remap = require("larssonoliver.keymap")
local nnoremap = remap.nnoremap
local vnoremap = remap.vnoremap
-- local inoremap = remap.inoremap
-- local xnoremap = remap.xnoremap
local nmap = remap.nmap

if vim.g.loaded_netrw == 1 then
    nnoremap("<leader>pv", "<cmd>Ex<CR>")
else
    nnoremap("<leader>pv", "<cmd>NvimTreeFocus<CR>")
end

nnoremap("<leader>x", "<cmd>!chmod +x %<CR>")

nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")

nnoremap("<C-_>", "<cmd>CommentToggle<CR>")
vnoremap("<C-_>", ":'<,'>CommentToggle<CR>")

