-- ~/.config/nvim/lua/plugins/venv.lua
return {
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    opts = {
      name = ".venv",
      auto_refresh = true,
      search = { cwd = true },
      update_nvim_env = true,
    },
  },
  -- Configure pyright to find .venv before it starts
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local venv_path = vim.fn.getcwd() .. "/.venv"
            if vim.fn.isdirectory(venv_path) == 1 then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv_path .. "/bin/python"
              config.settings.python.venvPath = vim.fn.getcwd()
              config.settings.python.venv = ".venv"
            end
          end,
        },
      },
    },
  },
}
