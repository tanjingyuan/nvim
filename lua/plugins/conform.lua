return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.formatters_by_ft = {
      lua = { "stylua" },
      -- fish = { "fish_indent" },
      shell = { "shfmt" },
      cpp = { "clang-format" },
      c = { "clang-format" },
      cmake = { "cmake-format" },
    }
    return opts
  end,
}
