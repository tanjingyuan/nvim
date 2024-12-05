local M = {}

local function get_neo_tree_path()
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  return state.path
end

local function neo_tree_live_grep()
  local path = get_neo_tree_path()
  require("telescope.builtin").live_grep({
    cwd = path,
    prompt_title = "Live Grep in current Neo-tree Path",
  })
end

local function neo_tree_find_files()
  local path = get_neo_tree_path()
  require("telescope.builtin").find_files({
    cwd = path,
    prompt_title = "Find Files in current Neo-tree Path",
  })
end

local function neo_tree_find_workspace_files()
  local path = get_neo_tree_path()
  require("telescope.builtin").find_files({
    prompt_title = "Find Files in workspace Neo-tree Path",
  })
end

local function neo_tree_find_directory()
  local path = get_neo_tree_path()
  require("telescope.builtin").find_files({
    cwd = path,
    find_command = { "find", ".", "-type", "d", "-not", "-path", "*/.*" },
    prompt_title = "Find current Directories",
  })
end

local function neo_tree_find_workspace_directory()
  local path = get_neo_tree_path()
  require("telescope.builtin").find_files({
    cwd = path,
    find_command = { "find", ".", "-type", "d", "-not", "-path", "*/.*" },
    prompt_title = "Find workspace Directories",
  })
end

-- local function neo_tree_live_grep()
--   local path = get_neo_tree_path()
--   require("fzf-lua").live_grep({ cwd = path })
-- end
--
-- vim.keymap.set("n", "<leader>fC", neo_tree_live_grep, { noremap = true, silent = true, desc = "Neo-tree Live Grep" })-

-- local has_fzf, _ = pcall(require, "fzf-lua")
-- if has_fzf then
--   vim.notify("fzf-lua is installed", vim.log.levels.INFO)
-- else
--   vim.notify("fzf-lua is not installed", vim.log.levels.WARN)
-- end

function M.setup()
  vim.keymap.set("n", "<leader>fw", neo_tree_live_grep, { noremap = true, silent = true, desc = "Neo-tree Live Grep" })
  vim.keymap.set(
    "n",
    "<leader>ff",
    neo_tree_find_files,
    { noremap = true, silent = true, desc = "Neo-tree Find current files" }
  )

  vim.keymap.set(
    "n",
    "<leader>fF",
    neo_tree_find_workspace_files,
    { noremap = true, silent = true, desc = "Neo-tree Find workspace files" }
  )

  vim.keymap.set(
    "n",
    "<leader>fd",
    neo_tree_find_directory,
    { noremap = true, silent = true, desc = "Neo-tree Find current directories" }
  )
  vim.keymap.set(
    "n",
    "<leader>fD",
    neo_tree_find_workspace_directory,
    { noremap = true, silent = true, desc = "Neo-tree Find workspace directories" }
  )
end

return M
