return {
  "akinsho/nvim-toggleterm.lua",
  event = "VeryLazy",
  config = function()
    local user_shell = vim.env.SHELL or "/bin/bash"
    vim.opt.shell = user_shell
    vim.opt.shellcmdflag = "-ic"
    local shell_with_login = user_shell .. " -l"
    require("toggleterm").setup({
      direction = "horizontal",
      on_open = function(term)
        vim.cmd("startinsert!")
      end,
      shell = shell_with_login,
      start_in_insert = true,
      close_on_exit = true,
    })
  end,
  cmd = "ToggleTerm",
}
