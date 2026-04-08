return {
  {
    "folke/todo-comments.nvim",
    opts = function(_, opts)
      -- keep todo-comments for normal tags only
      opts.merge_keywords = true
      return opts
    end,
    config = function(_, opts)
      require("todo-comments").setup(opts)

      local ns = vim.api.nvim_create_namespace("better_comments")

      local leaders = { "#", "//", "--", ";", "%" }

      local function startswith(s, prefix)
        return s:sub(1, #prefix) == prefix
      end

      local function parse_line(line)
        local indent = line:match("^%s*") or ""
        local after_indent = line:sub(#indent + 1)

        for _, leader in ipairs(leaders) do
          if startswith(after_indent, leader) then
            local after_leader = after_indent:sub(#leader + 1)
            local ws = after_leader:match("^%s*") or ""
            local rest = after_leader:sub(#ws + 1)

            local start_col = #indent + #leader + #ws
            local lower = rest:lower()

            -- order matters (// must come before /)
            if startswith(rest, "//") then
              return "BetterCommentRemoved", start_col
            end
            if startswith(rest, "!") then
              return "BetterCommentAlert", start_col
            end
            if startswith(rest, "?") then
              return "BetterCommentQuery", start_col
            end
            if lower:find("^todo%f[%W]") then
              return "BetterCommentTodo", start_col
            end
            if startswith(rest, "*") then
              return "BetterCommentHighlight", start_col
            end

            return nil, nil
          end
        end

        return nil, nil
      end

      local function apply(buf)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local bo = vim.bo[buf]
        if bo.buftype ~= "" then
          return
        end

        -- guardrail: don’t melt large files
        if vim.api.nvim_buf_line_count(buf) > 10000 then
          return
        end

        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for i, line in ipairs(lines) do
          local hl, col = parse_line(line)
          if hl then
            vim.api.nvim_buf_add_highlight(buf, ns, hl, i - 1, col, -1)
          end
        end
      end

      -- Better Comments colors (from VSCode extension)
      vim.api.nvim_set_hl(0, "BetterCommentAlert", {
        fg = "#FF2D00",
      })
      vim.api.nvim_set_hl(0, "BetterCommentQuery", {
        fg = "#3498DB",
      })
      vim.api.nvim_set_hl(0, "BetterCommentTodo", {
        fg = "#FF8C00",
      })
      vim.api.nvim_set_hl(0, "BetterCommentHighlight", {
        fg = "#98C379",
      })
      vim.api.nvim_set_hl(0, "BetterCommentRemoved", {
        fg = "#474747",
        strikethrough = true,
      })

      local group = vim.api.nvim_create_augroup("better_comments_group", { clear = true })

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWinEnter",
        "TextChanged",
        "TextChangedI",
        "InsertLeave",
      }, {
        group = group,
        callback = function(args)
          apply(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          vim.api.nvim_set_hl(0, "BetterCommentAlert", { fg = "#FF2D00" })
          vim.api.nvim_set_hl(0, "BetterCommentQuery", { fg = "#3498DB" })
          vim.api.nvim_set_hl(0, "BetterCommentTodo", { fg = "#FF8C00" })
          vim.api.nvim_set_hl(0, "BetterCommentHighlight", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "BetterCommentRemoved", {
            fg = "#474747",
            strikethrough = true,
          })
        end,
      })
    end,
  },
}
