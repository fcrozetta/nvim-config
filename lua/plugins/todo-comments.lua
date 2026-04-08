return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local icon = vim.fn.nr2char

      return {
        signs = true,
        sign_priority = 8,
        merge_keywords = false,

        keywords = {
          FIX = {
            icon = icon(0xf188) .. " ", -- bug
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = {
            icon = icon(0xf00c) .. " ", -- check
            color = "warning",
            alt = { "todo" },
          },
          HACK = {
            icon = icon(0xf0a4) .. " ", -- hand/pointer
            color = "warning",
          },
          WARN = {
            icon = icon(0xf071) .. " ", -- warning
            color = "warning",
            alt = { "WARNING", "XXX" },
          },
          PERF = {
            icon = icon(0xf085) .. " ", -- gear
            color = "hint",
            alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
          },
          NOTE = {
            icon = icon(0xf128) .. " ", -- question/info-ish
            color = "info",
            alt = { "INFO" },
          },
          TEST = {
            icon = icon(0xf0ae) .. " ", -- tasks
            color = "test",
            alt = { "TESTING", "PASSED", "FAILED" },
          },
        },

        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },

        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },

        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#FF2D00" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FF8C00" },
          info = { "DiagnosticInfo", "#3498DB" },
          hint = { "DiagnosticHint", "#98C379" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#C678DD" },
        },

        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]],
        },
      }
    end,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      {
        "<leader>xt",
        "<cmd>Trouble todo toggle<cr>",
        desc = "Todo (Trouble)",
      },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
      {
        "<leader>st",
        "<cmd>TodoTelescope<cr>",
        desc = "Todo",
      },
      {
        "<leader>sT",
        "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
