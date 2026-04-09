-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
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
