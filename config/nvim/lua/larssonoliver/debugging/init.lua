local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

local remap = require("larssonoliver.keymap")
local nnoremap = remap.nnoremap

daptext.setup({})

dapui.setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    -- Use this to override mappings for specific elements
    element_mappings = {
        -- Example:
        -- stacks = {
        --   open = "<CR>",
        --   expand = "o",
        -- }
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    -- Layouts define sections of the screen to place windows.
    -- The position can be "left", "right", "top" or "bottom".
    -- The size specifies the height/width depending on position. It can be an Int
    -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- Elements are the elements shown in the layout (in order).
    -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "stacks",
                "breakpoints",
                "watches",
            },
            size = 30, -- 40 columns
            position = "left",
        },
        {
            elements = {
                "repl",
                -- "console",
            },
            size = 15, 
            position = "bottom",
        },
    },
    controls = {
        -- Requires Neovim nightly (or 0.8 when released)
        enabled = true,
        -- Display controls in this element
        element = "repl",
        icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
    }
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    if not vim.g.larssonoliver_tree_visible_before_dap_set then
        vim.g.larssonoliver_tree_visible_before_dap = require("nvim-tree.view").is_visible()
        vim.g.larssonoliver_tree_visible_before_dap_set = true
    end

    require("nvim-tree.api").tree.close()
    dapui.open({})
end

local on_dap_exit = function()
    dapui.close({})
    if vim.g.larssonoliver_tree_visible_before_dap then
        local api = require("nvim-tree.api")
        api.tree.close()
        require("nvim-tree.api").tree.toggle(false, true)
    end
    vim.g.larssonoliver_tree_visible_before_dap_set = false
end

dap.listeners.before.event_terminated["dapui_config"] = on_dap_exit
dap.listeners.before.event_exited["dapui_config"] = on_dap_exit

require("larssonoliver.debugging.node")
require("larssonoliver.debugging.python")

-- nnoremap("<Home>", function() dapui.toggle(1) end)
-- nnoremap("<End>", function() dapui.toggle(2) end)

nnoremap("<leader><leader>", function() dap.terminate() end)

nnoremap("<F5>", function() dap.continue() end)
nnoremap("<F10>", function() dap.step_over() end)
nnoremap("<F11>", function() dap.step_into() end)
--nnoremap("<Left>", function()
--    dap.step_out()
--end)
nnoremap("<Leader>b", function() dap.toggle_breakpoint() end)
nnoremap("<Leader>B", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
nnoremap("<leader>rc", function() dap.run_to_cursor() end)
