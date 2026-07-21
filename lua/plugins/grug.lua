return {
  "MagicDuck/grug-far.nvim",
  opts = {
    headerMaxWidth = 80,
    debouncedSearch = true,
  },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        if vim.fn.executable("rg") ~= 1 then
          vim.notify("ripgrep not found, please install it!", vim.log.levels.ERROR)
          return
        end
        local grug = require("grug-far")
        local current_file = vim.fn.expand("%:t")
        local current_dir = vim.fn.expand("%:p:h")
        grug.open({
          -- stay cache buffer
          -- transient = true,
          transient = false,
          prefills = {
            filesFilter = current_file,
            paths = current_dir,
            flags = "--word-regexp",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
