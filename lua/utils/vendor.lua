local M = {}

local function get_neo_tree_path()
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  return state.path
end

local function neo_tree_live_grep()
  local path = get_neo_tree_path()
  local display = vim.fn.fnamemodify(path or vim.uv.cwd(), ":~")
  vim.notify(string.format("搜索目录: %s", display), vim.log.levels.INFO, { title = "Snacks 搜索" })
  Snacks.picker.grep({
    cwd = path,
    regex = false,
    title = "模糊搜索",
  })
end

local function neo_tree_fixed_live_grep()
  local path = get_neo_tree_path()
  local display = vim.fn.fnamemodify(path or vim.uv.cwd(), ":~")
  vim.notify(string.format("搜索目录: %s", display), vim.log.levels.INFO, { title = "Snacks 搜索" })
  Snacks.picker.grep({
    cwd = path,
    regex = false,
    title = "固定字符串搜索",
  })
end

local function neo_tree_exact_live_grep()
  local path = get_neo_tree_path()
  local display = vim.fn.fnamemodify(path or vim.uv.cwd(), ":~")
  vim.notify(string.format("搜索目录: %s", display), vim.log.levels.INFO, { title = "Snacks 搜索" })
  Snacks.picker.grep({
    cwd = path,
    regex = false,
    args = { "--case-sensitive", "--word-regexp" },
    title = "精确搜索 (区分大小写+完整单词)",
  })
end

local function neo_tree_find_files()
  local path = get_neo_tree_path()
  require("fzf-lua").files({
    cwd = path,
    prompt_title = "Find Files in current Neo-tree Path",
    -- 显示隐藏文件和被 gitignore 忽略的文件
    fd_opts = "--type f --hidden --no-ignore --exclude .git",
  })
end

local function neo_tree_find_workspace_files()
  require("fzf-lua").files({
    prompt_title = "Find Files in workspace Neo-tree Path",
    -- 显示隐藏文件和被 gitignore 忽略的文件
    fd_opts = "--type f --hidden --no-ignore --exclude .git",
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

-- 从主目录搜索目录，支持Tab补全
local function find_global_directory()
  local home = vim.fn.expand("~")

  -- 显示加载提示
  vim.notify("正在加载目录列表...", vim.log.levels.INFO, {
    title = "FZF 目录搜索",
    timeout = 1000,
  })

  -- 使用 fzf 的目录搜索功能
  require("fzf-lua").fzf_exec(
    function(fzf_cb)
      local cmd
      if vim.fn.executable("fd") == 1 then
        -- 使用 fd 时添加深度限制和排除大型目录
        cmd = "fd -t d -H --max-depth 3 --exclude node_modules --exclude .git --exclude .cache --base-directory "
            .. vim.fn.shellescape(home) .. " 2>/dev/null"
      else
        -- 使用 find 时添加深度限制和排除大型目录
        cmd = "find " .. vim.fn.shellescape(home)
            .. " -type d -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/.cache/*' 2>/dev/null"
            .. " | sed 's|" .. home .. "/||'"
      end

      -- 使用异步方式执行命令
      local co = coroutine.create(function()
        local handle = io.popen(cmd)
        if handle then
          for line in handle:lines() do
            fzf_cb(line)
          end
          handle:close()
        end
        fzf_cb()
      end)
      coroutine.resume(co)
    end,
    {
      prompt = "Global Folders> ",
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "horizontal",
          horizontal = "right:50%",
          delay = 100, -- 减少预览延迟
          title = "目录预览",
          title_pos = "center",
        },
      },
      previewer = "builtin",
      preview_opts = {
        builtin = {
          syntax = false,
          treesitter = false,
          delay = 100, -- 减少预览延迟
        },
      },
      fzf_opts = {
        -- 设置 Tab 键用于补全当前选中项
        ["--bind"] = "tab:replace-query,ctrl-j:down,ctrl-k:up",
        ["--preview"] = "ls -la --color=always " .. home .. "/{} | head -50", -- 限制预览内容数量
        ["--preview-window"] = "right:50%:wrap",
        ["--ansi"] = "",
        -- 启用补全功能
        ["--tabstop"] = "1",
        -- 提高性能的选项
        ["--no-hscroll"] = "",
        ["--info"] = "inline",
      },
      keymap = {
        -- 添加自定义按键映射
        fzf = {
          ["tab"] = "replace-query",         -- Tab 键替换查询为当前选中项
          ["ctrl-space"] = "toggle-preview", -- Ctrl+Space 切换预览窗口
          ["ctrl-d"] = "preview-page-down",  -- 预览窗口下翻页
          ["ctrl-u"] = "preview-page-up",    -- 预览窗口上翻页
        },
      },
      -- 添加缓存以提高性能
      _cached = true,
      actions = {
        ["default"] = function(selected)
          if selected and #selected > 0 then
            local dir = selected[1]
            local full_path = home .. "/" .. dir

            -- 检查目录是否存在
            if vim.fn.isdirectory(full_path) == 1 then
              -- 切换到目录
              vim.cmd("cd " .. vim.fn.fnameescape(full_path))
              -- 打开 Neo-tree 并显示当前目录
              vim.cmd("Neotree reveal")
              vim.notify("已切换到: " .. full_path, vim.log.levels.INFO)
            else
              vim.notify("目录不存在: " .. full_path, vim.log.levels.ERROR)
            end
          end
        end,
      },
    }
  )
end

-- 更现代的目录查找方式 (使用 fd 如果可用，否则回退到 find)
local function neo_tree_find_directory_modern()
  local path = get_neo_tree_path()
  -- 检查是否有 fd 命令
  local fd_cmd = vim.fn.executable("fd") == 1 and "fd -t d" or
      "find . -type d -not -path '*/.*' | sed 's|^./||' | grep -v '^$'"

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
    "<leader>fW",
    neo_tree_fixed_live_grep,
    { noremap = true, silent = true, desc = "Neo-tree Fixed String Grep" }
  )
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
    find_global_directory,
    { noremap = true, silent = true, desc = "Find directories from home with Tab completion" }
  )

end

return M
