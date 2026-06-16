-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Personal cheatsheet (curated markdown in a floating window)
vim.keymap.set("n", "<leader>h", function()
  require("config.cheatsheet").toggle()
end, { desc = "Cheatsheet" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-summary",
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true, nowait = true, remap = true }

    -- Jump to test under cursor (same as pressing `i`)
    vim.keymap.set("n", "<CR>", "i", opts)
    vim.keymap.set("n", "<leader>tj", "i", opts)

    vim.keymap.set("n", "<leader>te", "l", opts)
    vim.keymap.set("n", "<leader>to", "O", opts)
    vim.keymap.set("n", "q", "q", opts) -- keep close
  end,
})

-- Cycle through open buffers with Option+] / Option+[
vim.keymap.set("n", "<A-]>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<A-[>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Go to top of the enclosing function (its signature), via treesitter.
vim.keymap.set("n", "[f", function()
  local node = vim.treesitter.get_node()
  while node do
    local t = node:type()
    if t:find("function") or t:find("method") then
      local row, col = node:start()
      vim.api.nvim_win_set_cursor(0, { row + 1, col })
      return
    end
    node = node:parent()
  end
end, { desc = "Go to function signature" })

-- Quick edit .env file from project root
vim.keymap.set("n", "<leader>be", function()
  local root = LazyVim.root()
  local env_path = root .. "/.env"
  vim.cmd("edit " .. vim.fn.fnameescape(env_path))
end, { desc = "Edit .env" })

-- Copy project-relative file:line (or file:start-end in visual) for PR references
vim.keymap.set({ "n", "x" }, "<leader>cp", function()
  local root = LazyVim.root()
  local file = vim.api.nvim_buf_get_name(0)
  local rel = vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ":.")
  local ref
  if vim.fn.mode():find("[vV]") then
    local s = vim.fn.line("v")
    local e = vim.fn.line(".")
    if s > e then s, e = e, s end
    ref = s == e and string.format("%s:%d", rel, s) or string.format("%s:%d-%d", rel, s, e)
  else
    ref = string.format("%s:%d", rel, vim.fn.line("."))
  end
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref)
end, { desc = "Copy file:line (project-relative)" })

-- Copy a commit-pinned git permalink (current line / visual range).
-- Built by hand instead of via Snacks.gitbrowse(): gitbrowse only recognizes
-- the literal hosts github.com / gitlab.com / bitbucket.org, so it returns a
-- bare repo URL on self-hosted forges (e.g. gitlab.datenna.com). We still reuse
-- get_repo() for the remote -> https conversion (host-agnostic), then build the
-- path ourselves, picking the path style from the host.
vim.keymap.set({ "n", "x" }, "<leader>cP", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file in this buffer", vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(file, ":h")
  local function git(args)
    local out = vim.fn.system(vim.list_extend({ "git", "-C", dir }, args))
    return vim.v.shell_error == 0 and vim.trim(out) or nil
  end

  local relpath = git({ "ls-files", "--full-name", "--", file })
  if not relpath or relpath == "" then
    vim.notify("File isn't tracked in git", vim.log.levels.WARN)
    return
  end
  local sha = git({ "log", "-n", "1", "--pretty=format:%H", "--", file })
  if not sha or sha == "" then
    vim.notify("File has no commit yet — commit & push it before copying a permalink", vim.log.levels.WARN)
    return
  end
  local remote = git({ "remote", "get-url", "origin" })
  if not remote then
    vim.notify("No 'origin' remote found", vim.log.levels.WARN)
    return
  end
  local base = Snacks.gitbrowse.get_repo(remote) -- ssh/https -> https base, any host

  local s, e
  if vim.fn.mode():find("[vV]") then
    s, e = vim.fn.line("v"), vim.fn.line(".")
    if s > e then s, e = e, s end
  else
    s = vim.fn.line(".")
    e = s
  end

  local url
  if base:find("gitlab") then
    url = string.format("%s/-/blob/%s/%s#L%d-%d", base, sha, relpath, s, e)
  elseif base:find("bitbucket") then
    url = string.format("%s/src/%s/%s#lines-%d:%d", base, sha, relpath, s, e)
  else -- github.com, GitHub Enterprise, and most others
    url = string.format("%s/blob/%s/%s#L%d-L%d", base, sha, relpath, s, e)
  end

  vim.fn.setreg("+", url)
  vim.notify("Copied: " .. url)
end, { desc = "Copy git permalink (commit-pinned)" })

-- In lspsaga floating windows: allow <Esc> to close (q already works)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lspsaga*" },
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = bufnr, silent = true, nowait = true })
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = bufnr, silent = true, nowait = true })
  end,
})
