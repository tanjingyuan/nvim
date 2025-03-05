return {
  "rmagatti/goto-preview",
  event = { "VeryLazy" },
  config = function()
    -- local function center_preview(bufnr, winnr)
    --   vim.notify("center_preview called")
    --   local width = vim.api.nvim_win_get_option("columns")
    --   local height = vim.api.nvim_win_get_option("lines")
    --   local preview_width = vim.api.nvim_win_get_width(winnr)
    --   local preview_height = vim.api.nvim_win_get_height(winnr)
    --
    --   local row = math.floor((height - preview_height) / 2)
    --   local col = math.floor((width - preview_width) / 2)
    --
    --   vim.notify(
    --     string.format(
    --       "Editor: %dx%d, Preview: %dx%d, Position: row=%d, col=%d",
    --       width,
    --       height,
    --       preview_width,
    --       preview_height,
    --       row,
    --       col
    --     )
    --   )
    --
    --   vim.api.nvim_win_set_config(winnr, {
    --     relative = "editor",
    --     row = row,
    --     col = col,
    --   })
    -- end

    require("goto-preview").setup({
      width = 120,
      height = 15,
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
      default_mappings = false,
      debug = false,
      opacity = nil,
      resizing_mappings = false,
      post_open_hook = nil, -- 使用自定义函数来居中显示
      post_close_hook = nil,
      references = {
        telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
      },
      focus_on_open = true,
      dismiss_on_move = false,
      force_close = true,
      bufhidden = "wipe",
      stack_floating_preview_windows = true,
      same_file_float_preview = true,
      preview_window_title = { enable = true, position = "left" },
      zindex = 1,
    })
  end,
}
