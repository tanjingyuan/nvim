return {
  "akinsho/nvim-toggleterm.lua",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
      on_open = function(term)
        vim.cmd("startinsert!")
      end,
    })
  end,
  cmd = "ToggleTerm",
}
