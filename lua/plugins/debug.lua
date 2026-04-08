return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local InstallLocation = require("mason-core.installer.InstallLocation")
    local path = InstallLocation.global():package("debugpy")
    local python_path = path
      .. (vim.loop.os_uname().sysname:find("Windows") and "\\venv\\Scripts\\python.exe" or "/venv/bin/python")
    require("dap-python").setup(python_path)
  end,
}
