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

-- For telescope
--[[
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
]]

-- fzf
-- local function neo_tree_live_grep()
--   local path = get_neo_tree_path()
--   require("fzf-lua").live_grep({
--     cwd = path,
--     prompt_title = "Live Grep in current Neo-tree Path",
--   })
-- end

local function neo_tree_exact_live_grep()
  local path = get_neo_tree_path()
  require("fzf-lua").grep_project({
    cwd = path,
    prompt_title = "Live Grep in current Neo-tree Path",
  })
end

local function neo_tree_find_files()
  local path = get_neo_tree_path()
  require("fzf-lua").files({
    cwd = path,
    prompt_title = "Find Files in current Neo-tree Path",
  })
end

local function neo_tree_find_workspace_files()
  require("fzf-lua").files({
    prompt_title = "Find Files in workspace Neo-tree Path",
  })
end

local function neo_tree_find_directory()
  local path = get_neo_tree_path()
  require("fzf-lua").files({
    cwd = path,
    cmd = "find . -type d",
    prompt = "Folders> ",
    prompt_title = "Find current Directories",
  })
end

local function neo_tree_find_workspace_directory()
  require("fzf-lua").files({
    cmd = "find . -type d",
    prompt = "Folders> ",
    prompt_title = "Find current Directories",
  })
end

function M.setup()
  vim.keymap.set("n", "<leader>fw", neo_tree_live_grep, { noremap = true, silent = true, desc = "Neo-tree Live Grep" })
  vim.keymap.set(
    "n",
    "<leader>fa",
    neo_tree_exact_live_grep,
    { noremap = true, silent = true, desc = "Neo-tree Live Exact Grep" }
  )
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

  vim.api.nvim_create_autocmd("BufUnload", {
    pattern = "*.bin", -- 检查所有文件
    callback = function(ev)
      -- 检查文件类型是否为二进制
      local is_binary = vim.bo[ev.buf].binary

      if is_binary and vim.b[ev.buf].bigfile then
        vim.cmd("DoMatchParen")
        vim.notify(
          "Reactivated matchparen and syntax for binary file: " .. vim.fn.bufname(ev.buf),
          vim.log.levels.INFO,
          { title = "Binary File Closed" }
        )
      end
    end,
  })
end

return M
