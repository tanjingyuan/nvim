local M = {}

-- 状态变量，跟踪高亮是否启用
M.enabled = false

-- 常驻高亮
function M.dameon_highlights()
  local cursorline_bg = "#3d484d"
  local current_word_bg = "#475258"

  -- 设置当前行行号为醒目的橙色
  vim.cmd("highlight CursorLineNr guifg=#ff8800 gui=bold")

  -- 可选：设置普通行号颜色为稍微暗一些的颜色以形成对比
  vim.cmd("highlight LineNr guifg=#6b7280") --中灰色
  vim.cmd("highlight CursorLine guibg=" .. cursorline_bg) -- everforest bg2，更明显但不刺眼

  -- 括号匹配高亮（matchparen 使用 MatchParen 组）
  vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffb6c1", bg = "#ff5555", bold = true })

  -- 当前单词/同词引用高亮。比 CursorLine 再亮一档，避免两者糊在一起。
  for _, group in ipairs({
    "CurrentWord",
    "CurrentWordTwins",
    "illuminatedWord",
    "IlluminatedWordText",
    "IlluminatedWordRead",
    "IlluminatedWordWrite",
    "LspReferenceText",
    "LspReferenceRead",
    "LspReferenceWrite",
    "CursorWord0",
    "CursorWord1",
    "MiniCursorword",
    "MiniCursorwordCurrent",
  }) do
    vim.api.nvim_set_hl(0, group, { bg = current_word_bg, bold = true })
  end

  -- listchars 高亮（避免切换 colorscheme 后不明显）
  if vim.opt.list:get() then
    vim.api.nvim_set_hl(0, "Whitespace", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#f5c2e7", bold = true })
  end

  -- Diagnostics: 更醒目的错误/告警颜色（避免只看到行号轻微变色）
  -- 直接指定颜色 + 背景，避免某些主题把 Diagnostic 渲染成蓝色且不明显
  local diag = {
    error = { fg = "#ff3333", bg = "#2b0f0f" },
    warn = { fg = "#ffb347", bg = "#2b1f0f" },
    info = { fg = "#7fbbb3", bg = nil },
    hint = { fg = "#83c092", bg = nil },
  }

  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = diag.error.fg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = diag.warn.fg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = diag.info.fg })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = diag.hint.fg })

  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = diag.error.fg, bg = diag.error.bg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = diag.warn.fg, bg = diag.warn.bg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })

  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = diag.error.fg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = diag.warn.fg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { link = "DiagnosticHint" })

  vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { fg = diag.error.fg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { fg = diag.warn.fg, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { link = "DiagnosticHint" })

  -- undercurl 的“波浪线”也改成更亮的红/黄
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = diag.error.fg })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = diag.warn.fg })

  if vim.g.colors_name == "everforest" then
    vim.cmd("highlight IlluminatedWordText guibg=#425047") -- 暗绿色背景
    vim.cmd("highlight IlluminatedWordRead guibg=#425047") -- 暗绿色背景
    vim.cmd("highlight IlluminatedWordWrite guibg=#504945") -- 稍暗的棕色背景

    vim.cmd("highlight Visual guibg=#6c6f52") --橄榄黄
    -- vim.cmd("highlight Visual guibg=#445349 guifg=NONE") --绿灰色
  elseif vim.g.colors_name == "catppuccin-mocha" then
    vim.cmd("highlight Visual guibg=#135564") --青色
  else
  end
end

-- 应用高亮设置
function M.apply_highlights()
  M.dameon_highlights()

  vim.cmd([[
  highlight PmenuSel guibg=#4CAF50 guifg=#ffffff
]])

  vim.cmd([[
  highlight SelectedBracket guibg=#ff5555 guifg=#f8f8f2
]])

  -- 设置自动命令
  vim.cmd([[
augroup BracketHighlight
  autocmd!
  autocmd CursorMoved * silent! execute "match SelectedBracket /\\%#[({}\\[\\])]/"
augroup END
 ]])
end

-- 清除自定义高亮设置，保留主题原本设置
function M.clear_highlights()
  -- 清除自动命令
  vim.cmd([[
augroup BracketHighlight
  autocmd!
augroup END
]])

  -- 清除匹配高亮
  vim.cmd("match")

  -- 清除我们的自定义高亮组
  vim.cmd("highlight clear SelectedBracket")

  -- 恢复主题的默认高亮设置（通过重新加载颜色方案）
  local colorscheme = vim.g.colors_name
  if colorscheme then
    vim.cmd("colorscheme " .. colorscheme)
  end
end

-- 切换高亮功能
function M.toggle()
  if M.enabled then
    M.clear_highlights()
    M.enabled = false
    M.dameon_highlights()
    vim.notify("自定义高亮已禁用", vim.log.levels.INFO)
  else
    M.apply_highlights()
    M.enabled = true
    vim.notify("自定义高亮已启用", vim.log.levels.INFO)
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("UserHighlightOverrides", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      vim.schedule(function()
        M.dameon_highlights()
      end)
    end,
    desc = "Re-apply user highlight overrides after :colorscheme",
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LazyVimStarted",
    callback = function()
      vim.schedule(function()
        M.dameon_highlights()
      end)
    end,
    desc = "Re-apply user highlight overrides after LazyVim has fully started",
  })

  M.dameon_highlights()
  if M.enabled then
    M.apply_highlights()
  end
end

return M
