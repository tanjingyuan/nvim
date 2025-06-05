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

-- local function neo_tree_exact_live_grep()
--   local path = get_neo_tree_path()
--   require("fzf-lua").live_grep({
--     cwd = path,
--     fzf_opts = {
--       ["--exact"] = "",
--       ["--no-sort"] = "",
--     },
--     rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --word-regexp",
--     prompt_title = "精确搜索 (不区分大小写+完整单词)",
--   })
-- end

local function neo_tree_exact_live_grep()
  local path = get_neo_tree_path()
  require("fzf-lua").live_grep({
    cwd = path,
    fzf_opts = {
      ["--exact"] = "",
      ["--no-sort"] = "",
    },
    rg_opts = "--column --line-number --no-heading --color=always --case-sensitive --max-columns=4096 --word-regexp",
    prompt_title = "精确搜索 (区分大小写+完整单词)",
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
    cmd = "find . -type d -not -path '*/.*' | sed 's|^./||' | grep -v '^$'",
    prompt = "Folders> ",
    prompt_title = "查找目录 (当前路径)",
  })
end

local function neo_tree_find_workspace_directory()
  require("fzf-lua").files({
    cmd = "find . -type d -not -path '*/.*' | sed 's|^./||' | grep -v '^$'",
    prompt = "Folders> ",
    prompt_title = "查找目录 (工作空间)",
  })
end

-- 更现代的目录查找方式 (使用 fd 如果可用，否则回退到 find)
local function neo_tree_find_directory_modern()
  local path = get_neo_tree_path()
  -- 检查是否有 fd 命令
  local fd_cmd = vim.fn.executable("fd") == 1 and "fd -t d" or "find . -type d -not -path '*/.*' | sed 's|^./||' | grep -v '^$'"

  require("fzf-lua").files({
    cwd = path,
    cmd = fd_cmd,
    prompt = "📁 ",
    prompt_title = "现代目录查找",
  })
end

-- 快速跳转到常用目录
local function neo_tree_quick_directories()
  local current_path = get_neo_tree_path()
  local dirs = {}

  -- 递归获取所有子目录 (无深度限制)
  local function scan_directory(path, prefix)
    local handle = vim.loop.fs_scandir(path)
    if handle then
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end
        if type == "directory" and not name:match("^%.") and 
           name ~= "node_modules" and name ~= ".git" and name ~= ".cache" and
           name ~= "build" and name ~= "dist" and name ~= "target" and
           name ~= "__pycache__" and name ~= ".vscode" then
          local relative_path = prefix .. name
          local full_path = path .. "/" .. name
          table.insert(dirs, {
            path = relative_path,
            full_path = full_path,
            depth = string.len(prefix:gsub("[^/]", ""))
          })
          -- 递归扫描子目录 (无深度限制)
          scan_directory(full_path, relative_path .. "/")
        end
      end
    end
  end

  vim.notify("正在递归搜索所有目录...", vim.log.levels.INFO)

  -- 开始递归扫描，无深度限制
  scan_directory(current_path, "")

  if #dirs == 0 then
    vim.notify("当前目录下没有子目录", vim.log.levels.INFO)
    return
  end

  -- 按深度和名称排序
  table.sort(dirs, function(a, b)
    if a.depth ~= b.depth then
      return a.depth < b.depth
    end
    return a.path < b.path
  end)

  vim.ui.select(dirs, {
    prompt = string.format("选择目录 (找到 %d 个目录):", #dirs),
    format_item = function(item)
      local indent = string.rep("  ", item.depth)
      return indent .. "📁 " .. item.path
    end,
  }, function(choice)
    if choice then
      vim.cmd("Neotree dir=" .. choice.full_path)
    end
  end)
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
    neo_tree_quick_directories,
    { noremap = true, silent = true, desc = "Neo-tree Quick directory select" }
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
