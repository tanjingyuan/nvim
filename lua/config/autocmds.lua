-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Make telescope preview show line numbers
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
  end,
})

-- Dissable new line comment
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

local M = {}
M.add_project = function()
  local current_dir = vim.fn.expand('%:p:h')
  local project_name = vim.fn.fnamemodify(current_dir, ':t')
  vim.cmd("AddProject")
  vim.notify("Project added " .. project_name .. " successfully!", vim.log.levels.INFO)
end

return M
