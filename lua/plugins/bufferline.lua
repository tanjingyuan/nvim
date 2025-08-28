-- for everforest
return {
  "akinsho/bufferline.nvim",
  after = "everforest",
  config = function()
    require("bufferline").setup({
      options = {
        numbers = "ordinal",
        indicator = {
          icon = "▎",
          style = "underline",
        },
        separator_style = "thick",
        -- show_buffer_close_icons = false,
        -- show_close_icon = false,
        always_show_bufferline = true,
        diagnostics = false,
        themable = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
      highlights = {
        -- 普通 buffer 背景 (everforest 暗背景色)
        background = {
          fg = "#859289",
          bg = "#2d353b",
        },
        -- 当前选中的 buffer (突出显示)
        buffer_selected = {
          fg = "#d3c6aa", -- everforest 前景色
          bg = "#475258", -- 稍亮的背景
          bold = true,
          italic = false,
        },
        -- 选中的指示器 (everforest 绿色主题色)
        indicator_selected = {
          fg = "#a7c080", -- everforest 绿色
          bg = "#475258",
        },
        -- 选中的序号
        numbers_selected = {
          fg = "#a7c080", -- everforest 绿色
          bg = "#475258",
          bold = true,
        },
        -- 关闭按钮
        close_button = {
          fg = "#859289",
          bg = "#2d353b",
        },
        close_button_selected = {
          fg = "#d3c6aa",
          bg = "#475258",
        },
        -- 分隔符
        separator = {
          fg = "#232a2e", -- everforest 最暗背景
          bg = "#2d353b",
        },
        separator_selected = {
          fg = "#232a2e",
          bg = "#475258",
        },
        -- 标签页填充区域
        fill = {
          bg = "#232a2e", -- everforest 最暗背景
        },
        -- 可见但未选中的 buffer
        buffer_visible = {
          fg = "#9da9a0",
          bg = "#343f44",
        },
        numbers_visible = {
          fg = "#9da9a0",
          bg = "#343f44",
        },
      },
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

-- for catppuccin mocha
-- return {
--   "akinsho/bufferline.nvim",
--   after = "catppuccin",
--   config = function()
--     local mocha = require("catppuccin.palettes").get_palette("mocha")
--     require("bufferline").setup({
--       options = {
--         numbers = "ordinal",
--         indicator = {
--           style = "underline", -- 确保下划线模式开启
--         },
--       },
--       highlights = require("catppuccin.groups.integrations.bufferline").get({
--         styles = { "italic", "bold" },
--         custom = {
--           all = {
--             fill = { bg = mocha.base }, -- 注意这里应该用变量而不是字符串
--             indicator_selected = {
--               -- fp = mocha.red,
--               bg = mocha.red,
--               sp = mocha.red, -- 下划线颜色
--               -- underline = true,
--             },
--             buffer_selected = {
--               -- underline = true, -- 给整个标签加下划线
--             },
--           },
--           mocha = {
--             background = { fg = mocha.text },
--           },
--           latte = {
--             background = { fg = "#000000" },
--           },
--         },
--       }),
--     })
--     for i = 1, 9 do
--       vim.api.nvim_set_keymap(
--         "n",
--         string.format("<Leader>b%s", i),
--         string.format(":BufferLineGoToBuffer %s<CR>", i),
--         { noremap = true, silent = true }
--       )
--     end
--   end,
-- }
