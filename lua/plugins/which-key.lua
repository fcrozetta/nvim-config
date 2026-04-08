return {
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").add({
        { "<leader>t", group = "tests" },
      })
    end,
  },
}
