local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

local remap = require("larssonoliver.keymap")
local nnoremap = remap.nnoremap

daptext.setup({})
dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("larssonoliver.debugging.node")

nnoremap("<Home>", function() dapui.toggle(1) end)
nnoremap("<End>", function() dapui.toggle(2) end)

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
