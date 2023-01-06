vim.g.vimtex_view_method = "zathura"

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
