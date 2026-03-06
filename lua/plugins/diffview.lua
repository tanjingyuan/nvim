return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    local actions = require("diffview.actions")

    return {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      keymaps = {
        view = {
          ["<leader>e"] = actions.toggle_files,
          ["<leader>E"] = actions.focus_files,
          ["<leader>b"] = false,
        },
        file_panel = {
          ["<leader>e"] = actions.toggle_files,
          ["<leader>E"] = actions.focus_files,
          ["<leader>b"] = false,
        },
        file_history_panel = {
          ["<leader>e"] = actions.toggle_files,
          ["<leader>E"] = actions.focus_files,
          ["<leader>b"] = false,
        },
      },
    }
  end,
}
