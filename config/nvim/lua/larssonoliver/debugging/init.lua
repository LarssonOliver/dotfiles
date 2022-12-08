local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

local remap = require("larssonoliver.keymap")
local nnoremap = remap.nnoremap

daptext.setup({})
dapui.setup({})

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

-- nnoremap("<Home>", function() dapui.toggle(1) end)
-- nnoremap("<End>", function() dapui.toggle(2) end)

nnoremap("<leader><leader>", function() dap.close() end)

nnoremap("<F5>", function() dap.continue() end)
nnoremap("<F10>", function() dap.step_over() end)
nnoremap("<F11>", function() dap.step_into() end)
--nnoremap("<Left>", function()
--    dap.step_out()
--end)
nnoremap("<Leader>b", function() dap.toggle_breakpoint() end)
nnoremap("<Leader>B", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
nnoremap("<leader>rc", function() dap.run_to_cursor() end)
