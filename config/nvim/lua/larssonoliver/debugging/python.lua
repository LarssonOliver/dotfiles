local dap = require("dap")

dap.adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = {
        "-m", "debugpy.adapter"
    }
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch current file",
        program = "${file}",
        pythonPath = "/usr/bin/python3",
        stopOnEntry = true,
    },
}
