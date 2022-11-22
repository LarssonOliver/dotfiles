vim.api.nvim_create_user_command(
    "W",
    function(_)
        vim.api.nvim_command("write")
    end,
    {}
)
