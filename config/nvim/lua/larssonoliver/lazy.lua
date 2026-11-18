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
            "gbprod/nord.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                require("nord").setup({})
                vim.cmd.colorscheme("nord")
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

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                -- c, lua, markdown, query, vim and vimdoc ship with Neovim.
                -- LaTeX is left out on purpose: vimtex provides its own syntax.
                require("nvim-treesitter").install({
                    "bash",
                    "cpp",
                    "css",
                    "diff",
                    "dockerfile",
                    "git_config",
                    "gitcommit",
                    "go",
                    "gomod",
                    "hcl",
                    "helm",
                    "html",
                    "javascript",
                    "json",
                    "make",
                    "python",
                    "regex",
                    "sql",
                    "terraform",
                    "toml",
                    "tsx",
                    "typescript",
                    "vue",
                    "yaml",
                    "zig",
                })

                vim.api.nvim_create_autocmd("FileType", {
                    callback = function(event)
                        if not pcall(vim.treesitter.start, event.buf) then
                            return
                        end
                        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                        vim.wo[0][0].foldmethod = "expr"
                    end,
                })
            end,
        },

        -- Telescope
        {
            "nvim-telescope/telescope.nvim",
            version = "*",
            dependencies = { 
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            }
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
            cmd = { --[[ "CsvViewEnable", "CsvViewDisable", ]] "CsvViewToggle" },
        },

        -- LSP
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    "lua_ls",
                    "basedpyright",
                    "ruff",
                    "denols",
                    "bashls",
                    "cssls",
                    "emmet_language_server",
                    "eslint",
                    "gopls",
                    "helm_ls",
                    "ltex_plus",
                    "marksman",
                    "terraformls",
                    "tflint",
                    "vtsls",
                    "vue_ls",
                    "yamlls",
                },
                automatic_enable = true,
            },
            dependencies = {
                { "mason-org/mason.nvim", opts = {} },
                "neovim/nvim-lspconfig",
            },
        },
        { "b0o/SchemaStore.nvim", lazy = true },
        -- Detects the helm filetype that helm_ls attaches to.
        { "towolf/vim-helm" },

        -- Autocompletion. Snippets come from friendly-snippets and ./snippets.
        {
            "saghen/blink.cmp",
            version = "1.*",
            dependencies = {
                "rafamadriz/friendly-snippets",
                "fang2hou/blink-copilot",
            },
            opts = {
                keymap = {
                    preset = "default",
                    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                    -- Left to the LSP signature help mapping in after/plugin/lsp.lua.
                    ["<C-k>"] = false,
                },
                completion = {
                    list = { selection = { auto_insert = false } },
                    documentation = {
                        auto_show = true,
                        window = { border = "rounded" },
                    },
                    menu = {
                        draw = {
                            columns = {
                                { "label",     "label_description", gap = 1 },
                                { "kind_icon", "kind" },
                                { "source_name" },
                            },
                        },
                    },
                },
                sources = {
                    default = { "copilot", "lsp", "path", "snippets", "buffer" },
                    providers = {
                        copilot = {
                            name = "copilot",
                            module = "blink-copilot",
                            async = true,
                        },
                        buffer = { min_keyword_length = 3 },
                        snippets = { min_keyword_length = 2 },
                    },
                },
            },
        },

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

        { 'AndreM222/copilot-lualine' },
    }
})
