local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lspconfig_defaults.capabilities or {},
    require("cmp_nvim_lsp").default_capabilities()
)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "denols",
        "bashls",
        "cmake",
        "cssls",
        "emmet_language_server",
        "eslint",
        "gopls",
        "ltex",
        "marksman",
        "ts_ls",
        "volar",
        "yamlls",
    },
    handlers = {
        function(server_name) -- Default handler
            require("lspconfig")[server_name].setup({})
        end,

        lua_ls = function()
            require("lspconfig").lua_ls.setup({
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                                -- Depending on the usage, you might want to add additional paths here.
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            })
        end,

        volar = function()
            require("lspconfig").volar.setup({})
        end,

        ts_ls = function()
            local vue_typescript_plugin = require("mason-registry")
                .get_package("vue-language-server")
                :get_install_path()
                .. "/node_modules/@vue/language-server"
                .. "/node_modules/@vue/typescript-plugin"

            require("lspconfig").ts_ls.setup({
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
                root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json"),
                single_file_support = false,
            })
        end,

        denols = function()
            require("lspconfig").denols.setup({
                init_options = {
                    lint = true,
                    unstable = true,
                },
                root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc"),
                single_file_support = false,
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

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        vim.keymap.set("n", "K", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

        vim.keymap.set({ "n", "x" }, "<leader>f", vim.lsp.buf.format, opts)
    end,
})

local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

local details = true
local maxwidth = false

cmp.setup({
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
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ["<C-y>"] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
        ["<C-e>"] = cmp.mapping.abort(),

        -- open completion menu
        ["<C-Space>"] = cmp.mapping.complete(),

        -- navigate cmp items
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

        -- scroll documentation window
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
        ["<C-d>"] = cmp.mapping.scroll_docs(5),

    }),
    formatting = {
        fileds = details
            and { 'abbr', 'kind', 'menu' }
            or { 'abbr', 'menu', 'kind' },
        format = function(entry, item)
            local n = entry.source.name
            local label = ''

            if n == 'nvim_lsp' then
                label = '[LSP]'
            elseif n == 'nvim_lua' then
                label = '[nvim]'
            elseif n == 'luasnip' then
                label = '[snip]'
            elseif n == 'buffer' then
                label = '[buf]'
            else
                label = string.format('[%s]', n)
            end

            if details and item.menu ~= nil then
                item.menu = string.format('%s %s', label, item.menu)
            else
                item.menu = label
            end

            if maxwidth and #item.abbr > maxwidth then
                local last = item.kind == 'Snippet' and '~' or ''
                item.abbr = string.format(
                    '%s %s',
                    string.sub(item.abbr, 1, maxwidth),
                    last
                )
            end

            return item
        end,
    },
})

-- local cmp_action = lsp_zero.cmp_action()
-- local cmp_format = lsp_zero.cmp_format()
-- local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- require("luasnip.loaders.from_vscode").lazy_load()
-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

-- cmp.setup({
--     formatting = cmp_format,
--     preselect = "item",
--     completion = {
--         completeopt = "menu,menuone,noinsert"
--     },
--     window = {
--         documentation = cmp.config.window.bordered(),
--     },
--     sources = {
--         { name = "copilot" },
--         { name = "nvim_lsp" },
--         { name = "buffer",  keyword_length = 3 },
--         { name = "path" },
--         { name = "luasnip", keyword_length = 2 },
--     },
--     mapping = cmp.mapping.preset.insert({
--         -- confirm completion item
--         ["<C-y>"] = cmp.mapping.confirm({ select = false }),

--         -- toggle completion menu
--         ["<C-e>"] = cmp_action.toggle_completion(),

--         -- open completion menu
--         ["<C-Space>"] = cmp.mapping.complete(),

--         -- navigate cmp items
--         ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
--         ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

--         -- scroll documentation window
--         ["<C-u>"] = cmp.mapping.scroll_docs(-5),
--         ["<C-d>"] = cmp.mapping.scroll_docs(5),

--     }),
--     snippet = {
--         expand = function(args)
--             require("luasnip").lsp_expand(args.body)
--         end,
--     },

-- })

-- lsp_zero.on_attach(function(client, bufnr)
--     local opts = { buffer = bufnr, remap = false }

--     vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
--     vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

--     vim.keymap.set("n", "K", vim.lsp.buf.signature_help, opts)
--     vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

--     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
--     vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
--     vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

--     vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
--     vim.keymap.set("v", "ga", vim.lsp.buf.code_action, opts)

--     vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--     vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

--     vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
--     vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

--     -- https://dev.to/_hariti/solve-nvim-lsp-denols-vs-ts_ls-clash-ofd
--     local active_clients = vim.lsp.get_active_clients()
--     if client.name == "denols" then
--         for _, client_ in pairs(active_clients) do
--             -- stop ts_ls if denols is already active
--             if client_.name == "ts_ls" then
--                 client_.stop()
--             end
--         end
--     elseif client.name == "ts_ls" then
--         for _, client_ in pairs(active_clients) do
--             -- prevent ts_ls from starting if denols is already active
--             if client_.name == "denols" then
--                 client.stop()
--             end
--         end
--     end
-- end)
