return {
  {
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
        python = { "black" },
      }
      -- opts.formatters = { stylua = {
      --   command = vim.fn.expand("~/.cargo/bin/stylua"),
      -- } }
      return opts
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "shfmt",
        "clang-format",
        "cmakelang", -- 包含 cmake-format
        "yamlfix",
        "black",
        "prettier", -- 可选：用于 json, markdown 等
      })
    end,
  },
}
