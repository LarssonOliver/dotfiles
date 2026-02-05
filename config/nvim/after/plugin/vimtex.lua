if vim.fn.has("mac") == 1 then
  vim.g.vimtex_view_method = "skim"
  vim.g.vimtex_view_skim_sync = 1
  vim.g.vimtex_view_skim_activate = 1
elseif vim.fn.has("unix") == 1 then
  vim.g.vimtex_view_method = "zathura"
end

vim.g.vimtex_compiler_latexmk = {
    build_dir = "",
    callback = true,
    continuous = true,
    executable = "latexmk",
    hooks = {},
    options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-shell-escape',
    },
}
