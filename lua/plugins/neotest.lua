return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    config = function()
      local neotest = require("neotest")
      local neotest_python = require("neotest-python")

      neotest.setup({
        adapters = {
          neotest_python({
            runner = "pytest",
            python = function()
              local venv = vim.fn.getcwd() .. "/.venv/bin/python"
              if vim.fn.executable(venv) == 1 then
                return venv
              end
              return vim.fn.exepath("python3")
            end,
          }),
        },

        summary = {
          open = function()
            -- If summary already exists, focus it
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "neotest-summary" then
                vim.api.nvim_set_current_win(win)
                return
              end
            end

            -- Open split on the right
            vim.cmd("vsplit")
            vim.api.nvim_win_set_width(0, 40)
          end,
        },

        diagnostic = {
          enabled = true,
        },

        output = {
          open_on_run = "short",
        },
      })

      -- =========================
      -- Global Test Keymaps
      -- =========================

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      -- Summary
      -- map("<leader>ts", neotest.summary.toggle, "Tests: Toggle summary")
      map("<leader>ts", function()
        neotest.summary.toggle()

        -- if summary is now open, focus it
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neotest-summary" then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end, "Tests: Toggle summary (focus)")
      map("<leader>tS", neotest.summary.open, "Tests: Open summary")
      map("<leader>tc", neotest.summary.close, "Tests: Close summary")

      -- Run
      map("<leader>tn", function()
        neotest.run.run()
      end, "Tests: Run nearest")
      map("<leader>tr", function()
        neotest.run.run()
      end, "Tests: Run (nearest/selected)")
      map("<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, "Tests: Run file")

      map("<leader>tl", neotest.run.run_last, "Tests: Run last")

      -- Watch
      map("<leader>tW", function()
        neotest.run.run({ vim.fn.expand("%"), strategy = "watch" })
      end, "Tests: Watch file")

      -- Debug (requires nvim-dap)
      map("<leader>tD", function()
        neotest.run.run({ strategy = "dap" })
      end, "Tests: Debug nearest")

      -- Output
      map("<leader>to", function()
        neotest.output.open({ enter = true })
      end, "Tests: Open output")

      map("<leader>tO", neotest.output_panel.toggle, "Tests: Toggle output panel")

      -- Stop
      map("<leader>tq", neotest.run.stop, "Tests: Stop running")

      -- Jump (bridge to summary `i`)
      map("<leader>tj", function()
        if vim.bo.filetype == "neotest-summary" then
          vim.cmd("normal! i")
          return
        end

        neotest.summary.open()

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neotest-summary" then
            vim.api.nvim_set_current_win(win)
            break
          end
        end

        vim.cmd("normal! i")
      end, "Tests: Jump to selected test")
    end,
  },
}
