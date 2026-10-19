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
        cmake = { "cmake_format" },
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
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "shfmt",
        "tree-sitter-cli", -- 新版 Treesitter 使用 Mason 管理的 CLI，避免依赖系统旧版本
        "clang-format",
        "cmakelang", -- 包含 cmake-format
        "yamlfix",
        "black",
        "prettier", -- 可选：用于 json, markdown 等
      })
    end,
  },
}
