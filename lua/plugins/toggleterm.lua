return {
  "akinsho/nvim-toggleterm.lua",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
      on_open = function(term)
        vim.cmd("startinsert!")
      end,
    })

    vim.api.nvim_set_keymap("n", "<A-h>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
  end,
  cmd = "ToggleTerm",
}
