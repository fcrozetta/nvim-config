return {
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "kitty", -- or "ueberzug"/"sixel" depending on terminal
      processor = "magick_cli",
    },
  },
}
