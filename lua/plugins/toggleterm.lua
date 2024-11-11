return {
  "akinsho/nvim-toggleterm.lua",
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
    })
  end,
  cmd = "ToggleTerm",
}
