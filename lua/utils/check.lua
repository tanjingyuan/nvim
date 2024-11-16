local clipboard = require("utils.clipboard")
local system = require("utils.system")

local M = {}

function M.check()
  vim.api.nvim_create_user_command("Checkwsl", function()
    if system.is_wsl() then
      print("This is a WSL session")
    elseif system.is_mac() then
      print("This is a Mac session")
    else
      print("This is a local session")
    end
  end, {})

  vim.api.nvim_create_user_command("Checkremote", function()
    if system.is_remote() then
      print("This is a Remote session")
    else
      print("This is a local session")
    end
  end, {})
end

return M
