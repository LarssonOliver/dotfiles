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
        requires = { { "kyazdani42/nvim-web-devicons" } },
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
            })
        end
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { { "nvim-lua/plenary.nvim" } }
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    })
    --
    -- Editorconfig
    use("gpanders/editorconfig.nvim")

    -- TeX
    use("lervag/vimtex")

    -- LSP
    use({
        'VonHeikemen/lsp-zero.nvim',
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

    -- Debugging
    use({
        "mfussenegger/nvim-dap",
        requires = {
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
