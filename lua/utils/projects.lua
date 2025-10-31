-- 项目管理辅助模块
local M = {}

-- 项目列表保存路径
local projects_file = vim.fn.stdpath("data") .. "/snacks_projects.json"

local function normalize_path(path)
  if not path or path == "" then
    return nil
  end
  local normalized = vim.fs.normalize(path)
  if normalized:sub(-1) == "/" then
    normalized = normalized:sub(1, -2)
  end
  return normalized
end

local function normalize_list(projects)
  local normalized = {}
  local seen = {}
  for _, proj in ipairs(projects or {}) do
    local path = normalize_path(proj)
    if path and not seen[path] then
      seen[path] = true
      table.insert(normalized, path)
    end
  end
  return normalized
end

-- 读取保存的项目列表
function M.load_projects()
  local file = io.open(projects_file, "r")
  if not file then
    return {}
  end
  local content = file:read("*a")
  file:close()
  local ok, projects = pcall(vim.json.decode, content)
  if not ok or type(projects) ~= "table" then
    return {}
  end
  local normalized = normalize_list(projects)
  if #normalized ~= #projects then
    M.save_projects(normalized)
  end
  return normalized
end

-- 保存项目列表
function M.save_projects(projects)
  local normalized = normalize_list(projects)
  local file = io.open(projects_file, "w")
  if not file then
    vim.notify("Failed to save projects!", vim.log.levels.ERROR)
    return false
  end
  file:write(vim.json.encode(normalized))
  file:close()
  return true
end

-- 添加项目
function M.add_project(dir)
  dir = normalize_path(dir)
  if not dir then
    return false, "invalid path"
  end

  local projects = M.load_projects()

  -- 检查是否已存在
  for _, proj in ipairs(projects) do
    if proj == dir then
      return false, "already exists"
    end
  end

  -- 添加项目
  table.insert(projects, dir)
  M.save_projects(projects)
  return true, "added"
end

-- 删除项目
function M.remove_project(dir)
  dir = normalize_path(dir)
  if not dir then
    return false
  end

  local projects = M.load_projects()
  local found = false

  for i, proj in ipairs(projects) do
    if proj == dir then
      table.remove(projects, i)
      found = true
      break
    end
  end

  if found then
    M.save_projects(projects)
  end

  return found
end

return M
