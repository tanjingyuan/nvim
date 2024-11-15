local M = {}

function M.is_wsl()
  return vim.env.WSL_DISTRO_NAME ~= nil
end

function M.is_remote()
  return vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
end

function M.paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

return M
