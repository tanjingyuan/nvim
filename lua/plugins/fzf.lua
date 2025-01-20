return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      keymap = {
        fzf = {
          ["ctrl-n"] = "donw",
          ["ctrl-p"] = "up",
          -- ["alt-n"] = "next-history",
          -- ["alt-p"] = "previous-history",
        },
      },
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        ["--cycle"] = true,
        ["--highlight-line"] = true, -- fzf >= v0.53
        ["--info"] = "inline-right", -- fzf < v0.42 = "inline"
      },
    })
  end,
  config = function()
    require("fzf-lua").setup({
      "telescope",
    })
  end,
}
