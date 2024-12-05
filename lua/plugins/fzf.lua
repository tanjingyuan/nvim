return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      keymap = {
        fzf = {
          ["alt-n"] = "next-history",
          ["alt-p"] = "previous-history",
        },
      },
      -- files = {
      --   fzf_opts = {
      --     ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
      --   },
      -- },
      grep = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        },
      },
    })
  end,
}
