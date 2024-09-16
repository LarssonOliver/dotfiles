local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- My plugins here

    -- Theme
    use({
        "shaunsingh/nord.nvim",
        config = function()
            vim.g.nord_borders = true
            vim.g.nord_contrast = true
            vim.cmd("colorscheme nord")
        end
    })

    -- Statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = { { "nvim-tree/nvim-web-devicons" } },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "nord"
                }
            })
        end
    })

    -- Commenting
    use({
        "terrortylor/nvim-comment",
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
                end
            })
        end
    })

    -- Git conflicts
    use({
        "akinsho/git-conflict.nvim",
        tag = "*",
        config = function()
            require("git-conflict").setup()
        end
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { { "nvim-lua/plenary.nvim" } }
    })

    -- Oil
    use({
        "stevearc/oil.nvim",
        requires = { { "nvim-tree/nvim-web-devicons" } },
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
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    })

    -- TMUX
    use("christoomey/vim-tmux-navigator")

    -- TeX
    use("lervag/vimtex")

    -- Indent visuals
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = {
                    show_start = false,
                    show_end = false,
                }
            })
        end
    })

    -- LSP
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = "v3.x",
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        }
    })

    -- Copilot, lazy loaded, initiate with ":Copilot auth"
    use({
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
    })

    use({
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    })

    -- Debugging
    use({
        "mfussenegger/nvim-dap",
        requires = {
            { "nvim-neotest/nvim-nio" },
            { "rcarriga/nvim-dap-ui" },
            { "theHamsta/nvim-dap-virtual-text" },
            { "mxsdev/nvim-dap-vscode-js" }
        }
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
