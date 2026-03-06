local system = require("utils.system")

local M = {}

function M.setup()
  -- 不要把 unnamed 直接绑定到系统剪贴板：
  -- 否则像 `cw`/`dw` 这类删除/修改操作会覆盖系统剪贴板（外部 Ctrl+V 会被影响）。
  vim.o.clipboard = ""

  if system.is_docker() then
    -- Docker 环境下使用 OSC 52 协议
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      },
    }
  elseif system.is_wsl() then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ["*"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      cache_enabled = 0,
    }
  elseif system.is_remote() then
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = system.paste,
        ["*"] = system.paste,
      },
    }
  elseif system.is_mac() then
    vim.g.clipboard = {
      name = "macOSClipboard",
      copy = {
        ["+"] = "pbcopy",
        ["*"] = "pbcopy",
      },
      paste = {
        ["+"] = "pbpaste",
        ["*"] = "pbpaste",
      },
      cache_enabled = 0,
    }
  else
    -- 默认配置，可以是 xclip 或其他
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = "xclip -selection clipboard",
        ["*"] = "xclip -selection primary",
      },
      paste = {
        ["+"] = "xclip -selection clipboard -o",
        ["*"] = "xclip -selection primary -o",
      },
      cache_enabled = 0,
    }
  end

  -- 只在 yank 时同步到系统剪贴板，避免 delete/change 覆盖系统剪贴板
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("UserYankToClipboard", { clear = true }),
    callback = function()
      local event = vim.v.event
      if not event or event.operator ~= "y" then
        return
      end

      -- 只处理默认寄存器（""）或显式选择了系统剪贴板寄存器的 yank
      if event.regname ~= "" and event.regname ~= "+" and event.regname ~= "*" then
        return
      end

      local regtype = event.regtype
      local contents = event.regcontents or {}
      local text = table.concat(contents, "\n")

      -- 统一同步到 +/*，方便外部 Ctrl+V（以及部分系统使用的 primary selection）
      vim.fn.setreg("+", text, regtype)
      vim.fn.setreg("*", text, regtype)
    end,
    desc = "Sync yanks to system clipboard",
  })

  vim.api.nvim_set_keymap("v", "yy", ":OSCYankVisual<CR>", { noremap = true, silent = true })
end

return M
