-- ~/.config/nvim/lua/plugins/lspsaga.lua
return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
  -- Override LazyVim's LSP keymaps to use Lspsaga for peek
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            -- lowercase = peek (lspsaga)
            { "gd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
            { "gi", "<cmd>Lspsaga peek_implementation<cr>", desc = "Peek Implementation" },
            -- uppercase = jump (native LSP)
            { "gD", vim.lsp.buf.definition, desc = "Goto Definition" },
            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
          },
        },
      },
    },
  },
}
