-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    install = { colorscheme = { "nord" } },

    -- Auto checking for updates
    checker = { enabled = true, notify = false },

    spec = {
        -- Theme
        {
            "shaunsingh/nord.nvim",
            config = function()
                vim.g.nord_borders = true
                vim.g.nord_contrast = true
                vim.cmd("colorscheme nord")
            end
        },

        -- Statusline
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { { "nvim-tree/nvim-web-devicons" } },
            config = function()
                require("lualine").setup({
                    options = {
                        theme = "nord"
                    },
                    sections = {
                        lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' }
                    }
                })
            end
        },

        -- Commenting
        {
            "terrortylor/nvim-comment",
            dependencies = { { "JoosepAlviste/nvim-ts-context-commentstring" } },
            config = function()
                require("nvim_comment").setup({
                    comment_empty = false,
                    create_mappings = false,
                    hook = function()
                        local slash_comment_filetypes = { "cpp", "c", "zig", "openscad" }
                        for _, v in pairs(slash_comment_filetypes) do
                            if vim.api.nvim_buf_get_option(0, "filetype") == v then
                                vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
                                break
                            end
                        end
                        if vim.api.nvim_buf_get_option(0, "filetype") == "vue" then
                            require("ts_context_commentstring.internal").update_commentstring()
                        end
                    end
                })
            end
        },

        -- Git conflicts
        {
            "akinsho/git-conflict.nvim",
            version = "*",
            config = function()
                require("git-conflict").setup()
            end
        },

        -- Telescope
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = { { "nvim-lua/plenary.nvim" } }
        },

        -- Oil
        {
            "stevearc/oil.nvim",
            dependencies = { { "nvim-tree/nvim-web-devicons" } },
            config = function()
                require("oil").setup({
                    columns = {
                        "icon",
                        "permissions",
                    },
                    keymaps = {
                        -- Using to open telescope.
                        ["<C-p>"] = false,
                    },
                })
            end
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "javascript", "typescript", "c", "lua", "yaml" },
                    sync_install = false,
                    auto_install = true,
                    ignore_install = { "latex" },
                    highlight = {
                        enable = true,
                        disable = { "latex" },
                        additional_vim_regex_highlighting = true,
                    },
                })
            end
        },

        -- TMUX
        { "christoomey/vim-tmux-navigator" },

        -- TeX
        {
            "lervag/vimtex",
            lazy = false,
        },

        -- Indent visuals
        {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("ibl").setup({
                    scope = {
                        show_start = false,
                        show_end = false,
                    }
                })
            end
        },

        -- Jump visuals
        {
            "jinh0/eyeliner.nvim",
            config = function()
                require("eyeliner").setup({
                    highlight_on_key = true,
                    dim = true,
                })
            end,
        },

        -- CSV Visualization
        {
            "hat0uma/csvview.nvim",
            opts = {
                parser = { comments = { "#", "//" } },
            },
            cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
        },

        -- LSP
        { 'neovim/nvim-lspconfig' },
        {
            'williamboman/mason.nvim',
            dependencies = { 'williamboman/mason-lspconfig.nvim' }
        },

        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-nvim-lua',
            }
        },

        -- Snippets
        { 'L3MON4D3/LuaSnip' },
        -- Snippet Collection (Optional)
        { 'rafamadriz/friendly-snippets' },

        -- Copilot, lazy loaded, initiate with ":Copilot auth"
        {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            event = "InsertEnter",
            config = function()
                require("copilot").setup({
                    panel = {
                        enabled = false,
                    },
                    suggestion = {
                        enabled = false,
                    },
                    filetypes = {
                        -- markdown = false,
                    },
                })
            end,
        },

        {
            "zbirenbaum/copilot-cmp",
            dependencies = { "zbirenbaum/copilot.lua" },
            config = function()
                require("copilot_cmp").setup()
            end
        },

        { 'AndreM222/copilot-lualine' },

        -- Debugging
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                { "nvim-neotest/nvim-nio" },
                { "rcarriga/nvim-dap-ui" },
                { "theHamsta/nvim-dap-virtual-text" },
                { "mxsdev/nvim-dap-vscode-js" }
            }
        },
    }
})
