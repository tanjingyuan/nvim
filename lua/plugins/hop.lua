return {
  "phaazon/hop.nvim",
  keys = {
    {
      "<leader>h",
      function()
        require("hop").hint_lines()
      end,
      desc = "Hop Line",
    },
  },
  config = function()
    require("hop").setup()
  end,
}
