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

-- In lspsaga floating windows: allow <Esc> to close (q already works)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lspsaga*" },
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = bufnr, silent = true, nowait = true })
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = bufnr, silent = true, nowait = true })
  end,
})
