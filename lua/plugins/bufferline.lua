return {
  "akinsho/bufferline.nvim",
  after = "catppuccin",
  config = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    require("bufferline").setup({
      options = {
        numbers = "ordinal",
        indicator = {
          style = "underline", -- 确保下划线模式开启
        },
      },
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        styles = { "italic", "bold" },
        custom = {
          all = {
            fill = { bg = mocha.base }, -- 注意这里应该用变量而不是字符串
            indicator_selected = {
              -- fp = mocha.red,
              bg = mocha.red,
              sp = mocha.red, -- 下划线颜色
              -- underline = true,
            },
            buffer_selected = {
              -- underline = true, -- 给整个标签加下划线
            },
          },
          mocha = {
            background = { fg = mocha.text },
          },
          latte = {
            background = { fg = "#000000" },
          },
        },
      }),
    })
    for i = 1, 9 do
      vim.api.nvim_set_keymap(
        "n",
        string.format("<Leader>b%s", i),
        string.format(":BufferLineGoToBuffer %s<CR>", i),
        { noremap = true, silent = true }
      )
    end
  end,
}
