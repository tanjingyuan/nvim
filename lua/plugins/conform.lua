return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.formatters_by_ft = {
      lua = { "stylua" },
      -- fish = { "fish_indent" },
      sh = { "shfmt" },
      cpp = { "clang-format" },
      c = { "clang-format" },
      cmake = { "cmake-format" },
      yaml = { "yamlfix" },
    }
    return opts
  end,
}
