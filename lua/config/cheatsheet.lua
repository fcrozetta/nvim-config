-- Personal cheatsheet: a which-key-style floating panel.
-- Keys are colored using your theme's WhichKey* highlight groups.
-- Toggle with <leader>h; <C-w>w to focus back to your code and leave it open,
-- or `q`/<Esc> to close.
--
-- >>> Edit the `sections` table below to curate your shortcuts. <<<
local M = {}
M.win = nil

local sections = {
  {
    title = "Navigation",
    items = {
      { "<A-]>", "Next file buffer" },
      { "<A-[>", "Prev file buffer" },
      { "[f", "Go to top of function (signature)" },
      { "%", "Go to matching ()[]{}" },
    },
  },
  {
    title = "LSP",
    items = {
      { "gd", "Open definition popover" },
    },
  },
  {
    title = "Debug",
    items = {
      { "<leader>dF", "Debug API (FastAPI / uvicorn)" },
      { "<leader>db", "Toggle breakpoint" },
    },
  },
  {
    title = "Misc",
    items = {
      { "<leader>h", "Toggle this cheatsheet" },
    },
  },
}

local ns = vim.api.nvim_create_namespace("cheatsheet")

-- Build display lines plus highlight ranges (byte cols; keys are ASCII).
local function render()
  local keyw = 0
  for _, sec in ipairs(sections) do
    for _, item in ipairs(sec.items) do
      keyw = math.max(keyw, #item[1])
    end
  end

  local lines, hls = {}, {}
  local function add(text, ranges)
    lines[#lines + 1] = text
    for _, r in ipairs(ranges or {}) do
      hls[#hls + 1] = { line = #lines - 1, group = r.group, s = r.s, e = r.e }
    end
  end

  for si, sec in ipairs(sections) do
    if si > 1 then add("", {}) end
    add(sec.title, { { group = "WhichKeyGroup", s = 0, e = -1 } })
    for _, item in ipairs(sec.items) do
      local key = item[1]
      local pad = string.rep(" ", keyw - #key)
      local prefix = "  "
      local sep = "  "
      add(prefix .. key .. pad .. sep .. item[2], {
        { group = "WhichKey", s = #prefix, e = #prefix + #key },
        { group = "WhichKeyDesc", s = #prefix + #key, e = -1 },
      })
    end
  end
  return lines, hls
end

local function build_buf()
  local lines, hls = render()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, h in ipairs(hls) do
    vim.api.nvim_buf_add_highlight(buf, ns, h.group, h.line, h.s, h.e)
  end

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  return buf, width + 2, #lines
end

function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
end

function M.open()
  local buf, width, height = build_buf()
  M.win = vim.api.nvim_open_win(buf, false, { -- false = don't focus the float
    relative = "editor",
    width = width,
    height = height,
    row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, vim.o.columns - width - 3), -- hug the right side
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
    focusable = false, -- you can never land the cursor in it (like which-key)
    noautocmd = true,
  })
  vim.wo[M.win].winhighlight =
    "Normal:WhichKeyNormal,FloatBorder:WhichKeyBorder,FloatTitle:WhichKeyTitle"
end

function M.toggle()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    M.close()
  else
    M.open()
  end
end

return M
