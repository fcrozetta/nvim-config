-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.g.lazyvim_picker = "fzf" -- or
-- vim.g.lazyvim_picker = "telescope" -- if you prefer
vim.g.loaded_python3_provider = 0

local data_home = vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")
local pnpm_home = vim.env.PNPM_HOME or (data_home .. "/pnpm")

vim.env.PNPM_HOME = pnpm_home

if vim.env.PATH and not vim.env.PATH:find(pnpm_home, 1, true) then
  vim.env.PATH = pnpm_home .. ":" .. vim.env.PATH
end

vim.opt.title = true
vim.opt.titlestring = "nvim - %{fnamemodify(getcwd(),':t')}"
