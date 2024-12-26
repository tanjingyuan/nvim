local M = {}

function M.setup()
  vim.keymap.set("v", "<leader>csf", "<cmd>lua vim.lsp.buf.format()<CR>")
end

return M
