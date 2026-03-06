return {
  -- LazyVim 已自带 treesitter 的完整配置；这里仅做语言列表的增量扩展
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "cpp",
        "cuda",
        "proto",
        "textproto",
      })
      opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)

      -- `.prototxt` 属于 protobuf 的 text format（textproto），默认可能没有对应 parser 映射
      vim.treesitter.language.register("textproto", "prototxt")
    end,
  },
}
