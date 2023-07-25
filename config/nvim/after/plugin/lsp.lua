local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "lua_ls",
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I"
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
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

-- Custom lsp configs --

-- Fix Undefined global "vim"
require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
})

require("lspconfig").volar.setup({
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" }
})

require("lspconfig").yamlls.setup({
    settings = {
        redhat = {
            telemetry = {
                enabled = false
            }
        },
        schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
        },
        yaml = {
            -- https://www.reddit.com/r/neovim/comments/ze9gbe/comment/iz59clw
            schemas = {
                kubernetes = "*.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines.yml",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
            },
        }
    }
})

-- End custom lsp configs --

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
