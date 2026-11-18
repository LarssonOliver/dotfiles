vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
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

local vue_typescript_plugin_path = vim.fn.expand("$MASON")
    .. "/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("vtsls", {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = vue_typescript_plugin_path,
                        languages = { "vue" },
                        configNamespace = "typescript"
                    },
                }
            }
        }
    },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
})


-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/denols.lua
vim.g.markdown_fenced_languages = {
    "ts=typescript"
}
vim.lsp.config("denols", {
    -- init_options = {
    --     lint = true,
    --     unstable = true,
    -- },
    -- root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc"),
    -- single_file_support = false,
})

local yaml_schemas = require("schemastore").yaml.schemas({
    -- Match any YAML under policies/ and def/, which clashes with e.g. Kyverno policies.
    ignore = { "Aerleon Policy", "Aerleon Network & Service Definitions" },
})
yaml_schemas["https://spec.openapis.org/oas/3.1/schema/2025-09-15"] = {
    "openapi.yaml",
    "**/openapi/*.yaml",
    "**/*openapi*.yml",
}

-- Kubernetes version follows yaml-language-server's default; CRDs come from its datree catalog.
-- The Kubernetes schema takes priority over any other match, so files with a more specific
-- schema are excluded. Directory-wide patterns (e.g. "**/policies/**/*.yaml") are not
-- excluded as they would also catch real manifests; CI workflow directories are listed instead.
local kubernetes_files = {
    "*.yaml",
    "!**/.github/**",
    "!**/.gitea/**",
    "!**/.forgejo/**",
    "!**/.gitlab/**",
    -- Helm values files, which SchemaStore has no pattern for.
    "!**/values*.yaml",
}
for _, patterns in pairs(yaml_schemas) do
    for _, pattern in ipairs(type(patterns) == "table" and patterns or { patterns }) do
        local basename = pattern:match("[^/]*$")
        if basename:match("%.yaml$") and not basename:match("^%*+%.yaml$") then
            table.insert(kubernetes_files, "!" .. pattern)
        end
    end
end
yaml_schemas.kubernetes = kubernetes_files

vim.lsp.config("yamlls", {
    settings = {
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
        yaml = {
            -- Disable alphabetic ordering of keys warning.
            keyOrdering = false,

            -- SchemaStore.nvim provides the catalog instead.
            schemaStore = {
                enable = false,
                url = "",
            },
            schemas = yaml_schemas,
        }
    }
})

vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            -- Import sorting is handled by ruff.
            disableOrganizeImports = true,
        },
    },
})

-- Show the diagnostic in a float after jumping with the built-in ]d/[d/]D/[D.
vim.diagnostic.config({
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
        end,
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        -- basedpyright provides hover; avoid ruff's duplicate.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
        end

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        -- nowait: don't wait for Neovim's built-in grn/gra/grr/gri/grt.
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf, nowait = true })
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

        vim.keymap.set({ "n", "x" }, "<leader>f", vim.lsp.buf.format, opts)
    end,
})
