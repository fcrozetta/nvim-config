return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mfussenegger/nvim-dap" },
  keys = {
    -- Debug API: launch FastAPI under uvicorn + debugpy.
    -- No --reload: the reloader spawns a child the debugger can't attach to.
    {
      "<leader>dF",
      function()
        vim.ui.input({ prompt = "ASGI app (module:app): ", default = "app.main:app" }, function(target)
          if not target or target == "" then
            return
          end
          require("dap").run({
            type = "python",
            request = "launch",
            name = "Debug FastAPI (uvicorn)",
            module = "uvicorn",
            args = { target, "--host", "127.0.0.1", "--port", "8000" },
            console = "integratedTerminal",
            justMyCode = false,
          })
        end)
      end,
      desc = "Debug FastAPI (uvicorn)",
    },
  },
  config = function()
    local InstallLocation = require("mason-core.installer.InstallLocation")
    local path = InstallLocation.global():package("debugpy")
    local python_path = path
      .. (vim.loop.os_uname().sysname:find("Windows") and "\\venv\\Scripts\\python.exe" or "/venv/bin/python")
    require("dap-python").setup(python_path)
  end,
}
