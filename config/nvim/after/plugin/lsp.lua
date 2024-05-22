local lsp_zero = require("lsp-zero")

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
    },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,

        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
        end,

        volar = function()
            require("lspconfig").volar.setup({})
        end,

        tsserver = function()
            local vue_typescript_plugin = require("mason-registry")
                .get_package("vue-language-server")
                :get_install_path()
                .. "/node_modules/@vue/language-server"
                .. "/node_modules/@vue/typescript-plugin"

            require("lspconfig").tsserver.setup({
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = vue_typescript_plugin,
                            languages = { "javascript", "typescript", "vue" }
                        },
                    }
                },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                    "vue",
                },
            })
        end,

        yamlls = function()
            require("lspconfig").yamlls.setup({
                settings = {
                    redhat = {
                        telemetry = {
                            enabled = false,
                        },
                    },
                    yaml = {
                        -- Disable alphabetic ordering of keys warning.
                        keyOrdering = false,

                        -- https://www.reddit.com/r/neovim/comments/ze9gbe/comment/iz59clw
                        schemas = {
                            kubernetes = "*.yaml",
                            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
                            "azure-pipelines.yml",
                            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
                            "*gitlab-ci*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                            "*api*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                            "*docker-compose*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                            "*flow*.{yml,yaml}",
                        },
                    }
                }
            })
        end,
    }
})

lsp_zero.set_sign_icons({
    error = "E",
    warn = "W",
    hint = "H",
    info = "I"
})

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

local cmp = require("cmp")
local cmp_action = lsp_zero.cmp_action()
local cmp_format = lsp_zero.cmp_format()
local cmp_select = { behavior = cmp.SelectBehavior.Select }

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

cmp.setup({
    formatting = cmp_format,
    preselect = "item",
    completion = {
        completeopt = "menu,menuone,noinsert"
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "buffer",  keyword_length = 3 },
        { name = "path" },
        { name = "luasnip", keyword_length = 2 },
    },
    mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ["<C-y>"] = cmp.mapping.confirm({ select = false }),

        -- toggle completion menu
        ["<C-e>"] = cmp_action.toggle_completion(),

        -- open completion menu
        ["<C-Space>"] = cmp.mapping.complete(),

        -- navigate cmp items
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

        -- scroll documentation window
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
        ["<C-d>"] = cmp.mapping.scroll_docs(5),

    }),
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

})

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("v", "ga", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

    -- https://dev.to/_hariti/solve-nvim-lsp-denols-vs-tsserver-clash-ofd
    local active_clients = vim.lsp.get_active_clients()
    if client.name == "denols" then
        for _, client_ in pairs(active_clients) do
            -- stop tsserver if denols is already active
            if client_.name == "tsserver" then
                client_.stop()
            end
        end
    elseif client.name == "tsserver" then
        for _, client_ in pairs(active_clients) do
            -- prevent tsserver from starting if denols is already active
            if client_.name == "denols" then
                client.stop()
            end
        end
    end
end)
