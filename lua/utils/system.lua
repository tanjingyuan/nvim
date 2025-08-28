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

function M.paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

function M.setup()
  if M.is_remote() then
    vim.g.autoformat = false
  else
    vim.g.autoformat = false
  end
end

return M
