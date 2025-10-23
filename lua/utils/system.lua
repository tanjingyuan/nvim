local M = {}

function M.is_wsl()
  return vim.env.WSL_DISTRO_NAME ~= nil
end

function M.is_remote()
  return vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
end

function M.is_mac()
  return vim.loop.os_uname().sysname == "Darwin"
end

function M.is_docker()
  -- 检查是否在 Docker 容器中
  local dockerenv = vim.fn.filereadable("/.dockerenv") == 1
  if dockerenv then
    return true
  end

  -- 检查 cgroup 是否包含 docker
  local f = io.open("/proc/1/cgroup", "r")
  if f then
    local content = f:read("*all")
    f:close()
    return content:find("docker") ~= nil
  end

  return false
end

function M.paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

function M.setup()
  -- Ensure Mason-installed tools are available on PATH
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if vim.fn.isdirectory(mason_bin) == 1 then
    local current_path = vim.env.PATH or ""
    if not current_path:find(mason_bin, 1, true) then
      vim.env.PATH = mason_bin .. ":" .. current_path
    end
  end

  if M.is_remote() then
    vim.g.autoformat = false
  else
    vim.g.autoformat = false
  end
end

return M
