return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disable_mouse = false,
    disabled_filetypes = { "log", "neo-tree", "mason", "prototxt", "lazy" },
  },
  config = function(_, opts)
    require("hardtime").setup(opts)
  end,
}
