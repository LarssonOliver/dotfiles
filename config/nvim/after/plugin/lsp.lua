local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "sumneko_lua",
})

-- Fix Undefined global "vim"
lsp.configure("sumneko_lua", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
})

lsp.configure("tsserver", {
    root_dir = require("lspconfig").util.root_pattern(
        "package.json",
        "tsconfig.json",
        "jsconfig.json"
    )
})

-- Only run denols in deno projects
lsp.configure("denols", {
    root_dir = require("lspconfig").util.root_pattern(
        "deno.json",
        "deno.jsonc"
    )
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

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})


-- local remap = require("larssonoliver.keymap")
-- local nnoremap = remap.nnoremap

-- local cmp = require("cmp")
-- local source_mapping = {
--     buffer = "[Buffer]",
--     nvim_lsp = "[LSP]",
--     nvim_lua = "[Lua]",
--     cmp_tabnine = "[TN]",
--     path = "[Path]",
-- }

-- local lspkind = require("lspkind")

-- cmp.setup({
--     snippet = {
--         expand = function(args)
--             require("luasnip").lsp_expand(args.body)
--         end
--     },
--     mapping = cmp.mapping.preset.insert({
--         ["<C-u>"] = cmp.mapping.scroll_docs(-4),
--         ["<C-d>"] = cmp.mapping.scroll_docs(4),
--         ["<C-Space>"] = cmp.mapping.complete(),
--         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         ["<tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--     }),
--     formatting = {
--         format = function(entry, vim_item)
--             vim_item.kind = lspkind.presets.default[vim_item.kind]
--             local menu = source_mapping[entry.source.name]
--             if entry.source.name == "cmp_tabnine" then
--                 if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
--                     menu = entry.completion_item.data.detail .. " " .. menu
--                 end
--                 vim_item.kind = ""
--             end
--             vim_item.menu = menu
--             return vim_item
--         end,

--     },
--     sources = {
--         { name = "cmp_tabnine" },
--         { name = "nvim_lsp" },
--         { name = "luasnip" },
--         { name = "buffer" },
--     },
-- })

-- local tabnine = require("cmp_tabnine.config")
-- tabnine.setup({
--     max_lines = 1000,
--     max_num_results = 20,
--     sort = true,
--     run_on_every_keystroke = true,
--     snippet_placeholder = "..",
-- })

-- local function config(_config)
--     return vim.tbl_deep_extend("force", {
--         on_attach = function()
--             nnoremap("[d", function() vim.diagnostic.goto_next() end)
--             nnoremap("]d", function() vim.diagnostic.goto_prev() end)

--             nnoremap("gD", function() vim.lsp.buf.declaration() end)
--             nnoremap("gd", function() vim.lsp.buf.definition() end)
--             nnoremap("K", function() vim.lsp.buf.hover() end)
--             nnoremap("gi", function() vim.lsp.buf.implementation() end)
--             nnoremap("<C-k>", function() vim.lsp.buf.signature_help() end)
--             nnoremap("<leader>wa", function() vim.lsp.buf.add_workspace_folder() end)
--             nnoremap("<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end)
--             nnoremap("<leader>wl", function()
--                 print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--             end)
--             nnoremap("<leader>D", function() vim.lsp.buf.type_definition() end)
--             nnoremap("<leader>rn", function() vim.lsp.buf.rename() end)
--             nnoremap("<F2>", function() vim.lsp.buf.rename() end)
--             nnoremap("<leader>ca", function() vim.lsp.buf.code_action() end)
--             nnoremap("gr", function() vim.lsp.buf.references() end)
--             nnoremap("<leader>f", function() vim.lsp.buf.format { async = true } end)
--         end
--     }, _config or {})
-- end

-- require("lspconfig").bashls.setup(config())

-- require("lspconfig").yamlls.setup(config())

-- require("lspconfig").tsserver.setup(config({
--     root_dir = require("lspconfig").util.root_pattern(
--         "package.json",
--         "tsconfig.json",
--         "jsconfig.json"
--     )
-- }))

-- vim.g.markdown_fenced_languages = {
--     "ts=typescript"
-- }
-- require("lspconfig").denols.setup(config({
--     root_dir = require("lspconfig").util.root_pattern(
--         "deno.json",
--         "deno.jsonc"
--     )
-- }))

-- require("lspconfig").texlab.setup(config())

-- require("lspconfig").pyright.setup(config())

-- require("lspconfig").sumneko_lua.setup(config({
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
--                 version = "LuaJIT",
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = { "vim" },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = vim.api.nvim_get_runtime_file("", true),
--             },
--             -- Do not send telemetry data containing a randomized but unique identifier
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }))
