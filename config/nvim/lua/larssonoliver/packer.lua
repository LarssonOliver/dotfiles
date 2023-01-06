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
            vim.g.larssonoliver_colorscheme = "nord"
            vim.g.nord_borders = true
            vim.g.nord_contrast = true
            vim.cmd("colorscheme nord")
        end
    })

    -- Statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = { { "kyazdani42/nvim-web-devicons" } }
    })

    -- Commenting
    use("terrortylor/nvim-comment")

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

    -- -- LSP
    -- use("neovim/nvim-lspconfig")



    -- -- Autocompletion
    -- use("hrsh7th/cmp-nvim-lsp")
    -- use("hrsh7th/cmp-buffer")
    -- use("hrsh7th/nvim-cmp")
    -- use("L3MON4D3/LuaSnip")
    -- use("saadparwaiz1/cmp_luasnip")
    -- use("onsails/lspkind-nvim")
    -- use("tzachar/cmp-tabnine", {
    --     run = "./install.sh",
    --     requires = "hrsh7th/nvim-cmp",
    -- })


    -- -- Nvim-tree
    -- use({
    --     "nvim-tree/nvim-tree.lua",
    --     requires = { "nvim-tree/nvim-web-devicons", opt = true },
    -- })


    -- -- Debugging
    -- use("mfussenegger/nvim-dap")
    -- use("rcarriga/nvim-dap-ui")
    -- use("theHamsta/nvim-dap-virtual-text")
    -- use({
    --     "mxsdev/nvim-dap-vscode-js",
    --     requires = { "mfussenegger/nvim-dap" }
    -- })

    -- -- DAP servers
    -- use({
    --     "microsoft/vscode-js-debug",
    --     opt = true,
    --     run = "npm install --legacy-peer-deps && npm run compile"
    -- })


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
