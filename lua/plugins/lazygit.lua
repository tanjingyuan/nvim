return {
  "kdheepak/lazygit.nvim",
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
  config = function()
    -- 确保使用正确的 lazygit 配置文件
    vim.g.lazygit_config_file_path = vim.fn.expand("~/.config/lazygit/config.yml")
    vim.g.lazygit_use_custom_config_file_path = 1
  end,
}