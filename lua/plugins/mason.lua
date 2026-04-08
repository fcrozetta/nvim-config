return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Linters
        "hadolint",
        "markdownlint-cli2",
        "shellcheck",
        -- Formatters
        "shfmt",
        "stylua",
        -- DAP
        "debugpy",
        "js-debug-adapter",
        -- Tools
        "markdown-toc",
      },
    },
  },
}
