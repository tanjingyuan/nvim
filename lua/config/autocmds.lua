-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Make telescope preview show line numbers
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
  end,
})

-- Dissable new line comment
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

local M = {}

local function resolve_current_dir()
  -- 调试信息收集
  local debug_info = {}

  -- 1) 如果当前窗口是 Neo-tree，使用其根目录
  if vim.bo.filetype == "neo-tree" then
    table.insert(debug_info, "Current window is Neo-tree")
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if ok then
      local state = manager.get_state_for_window()
      if state and state.path then
        table.insert(debug_info, "Neo-tree state path: " .. state.path)
        -- 直接返回 Neo-tree 的根目录，不管选中了什么节点
        return vim.fs.normalize(state.path), debug_info
      end
    end
  end

  -- 2) 尝试在当前标签页查找一个已打开的 Neo-tree 窗口
  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if ok then
    table.insert(debug_info, "Searching for Neo-tree window")
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "neo-tree" then
        local state = manager.get_state_for_window(win)
        if state and state.path then
          table.insert(debug_info, "Found Neo-tree window with path: " .. state.path)
          -- 返回找到的 Neo-tree 窗口的根目录
          return vim.fs.normalize(state.path), debug_info
        end
      end
    end
  end

  -- 3) 如果没有 Neo-tree，则使用当前缓冲区的目录
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname and bufname ~= "" then
    local normalized = vim.fs.normalize(bufname)
    local dir = vim.fs.dirname(normalized)
    if dir and dir ~= "" then
      table.insert(debug_info, "Using current buffer dir: " .. dir)
      return dir, debug_info
    end
  end

  -- 4) 最后回退到 CWD
  local cwd = vim.loop.cwd() or vim.fn.getcwd()
  if cwd and cwd ~= "" then
    table.insert(debug_info, "Using CWD: " .. cwd)
    return vim.fs.normalize(cwd), debug_info
  end

  return nil, debug_info
end

-- 添加当前目录到 Snacks projects（支持调试模式）
M.add_project = function(debug, use_git_root)
  local current_dir, debug_info = resolve_current_dir()

  -- 如果开启调试，显示调试信息
  if debug then
    vim.notify("Debug info:\n" .. table.concat(debug_info, "\n"), vim.log.levels.INFO)
  end

  if not current_dir then
    vim.notify("⚠ 无法获取当前项目路径", vim.log.levels.WARN)
    return
  end

  local project_dir = current_dir

  -- 默认不使用 git root，除非明确指定
  if use_git_root ~= false then
    -- 尝试找到 git 根目录
    local git_root = ""
    if vim.loop.fs_stat(current_dir) then
      local cmd = string.format(
        "git -C %s rev-parse --show-toplevel 2>/dev/null",
        vim.fn.shellescape(current_dir)
      )
      git_root = vim.fn.systemlist(cmd)[1] or ""

      if debug and git_root ~= "" then
        vim.notify("Git root found: " .. git_root, vim.log.levels.INFO)
      end
    end

    -- 只在 git_root 确实在 current_dir 路径中时使用它
    if git_root ~= "" and current_dir:find(git_root, 1, true) then
      project_dir = git_root
    end
  end

  project_dir = vim.fn.fnamemodify(project_dir, ":p:h")
  local project_name = vim.fn.fnamemodify(project_dir, ":t")

  if debug then
    vim.notify("Final project_dir: " .. project_dir .. "\nProject name: " .. project_name, vim.log.levels.INFO)
  end

  local projects_utils = require("utils.projects")
  local ok, status = projects_utils.add_project(project_dir)

  if ok then
    vim.notify("✓ Project added: " .. project_name .. "\n" .. project_dir, vim.log.levels.INFO)
  else
    vim.notify("⚠ Project '" .. project_name .. "' " .. status .. "!", vim.log.levels.WARN)
  end
end

-- 添加调试命令
M.add_project_debug = function()
  M.add_project(true)
end

return M
