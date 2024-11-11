-- 在你的 Neovim 配置文件中添加以下代码
return {
  "folke/noice.nvim",
  keys = {
    -- 禁用默认的 flash 键映射
    { "<C-k>", mode = { "i" }, action = false },
  },
}
